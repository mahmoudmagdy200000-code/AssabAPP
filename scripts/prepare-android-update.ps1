[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateSet('staging', 'production')]
    [string]$Channel,

    [Parameter(Mandatory)]
    [ValidateSet('self-hosted-apk', 'play-store')]
    [string]$DistributionTarget,

    [Parameter(Mandatory)]
    [string]$ApkPath,

    [Parameter(Mandatory)]
    [string]$BaseApkUrl,

    [Parameter(Mandatory)]
    [string]$VersionCode,

    [Parameter(Mandatory)]
    [string]$VersionName,

    [Parameter(Mandatory)]
    [string]$ChangelogEn,

    [Parameter(Mandatory)]
    [string]$ChangelogAr,

    [string]$OutputDirectory = '.\update-release',
    [string]$ApkAnalyzer,
    [string]$ApkSigner
)

$ErrorActionPreference = 'Stop'

if ($DistributionTarget -ne 'self-hosted-apk') {
    throw 'The in-app update manifest is only for self-hosted APK distribution. Play Store builds must use Play-managed updates.'
}

function Resolve-AndroidTool {
    param([string]$ExplicitPath, [string]$CommandName, [string]$SdkRelativePath)

    if ($ExplicitPath) {
        if (-not (Test-Path -LiteralPath $ExplicitPath -PathType Leaf)) {
            throw "Android tool not found: $ExplicitPath"
        }
        return (Resolve-Path -LiteralPath $ExplicitPath).Path
    }

    $command = Get-Command $CommandName -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }

    if ($script:AndroidSdkRoot) {
        $candidate = $null
        if ($CommandName -eq 'apksigner.bat') {
            $buildTools = Join-Path $script:AndroidSdkRoot 'build-tools'
            $versionDirectory = Get-ChildItem -LiteralPath $buildTools -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match '^\d+(\.\d+)+$' } |
                Sort-Object { [version]$_.Name } -Descending |
                Select-Object -First 1
            if ($versionDirectory) { $candidate = Join-Path $versionDirectory.FullName $CommandName }
        } elseif ($CommandName -eq 'apkanalyzer.bat') {
            $cmdlineTools = Join-Path $script:AndroidSdkRoot 'cmdline-tools'
            $latestDirectory = Join-Path $cmdlineTools 'latest'
            if (Test-Path -LiteralPath $latestDirectory -PathType Container) {
                $candidate = Join-Path (Join-Path $latestDirectory 'bin') $CommandName
            } else {
                $versionDirectory = Get-ChildItem -LiteralPath $cmdlineTools -Directory -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -match '^\d+(\.\d+)+$' } |
                    Sort-Object { [version]$_.Name } -Descending |
                    Select-Object -First 1
                if ($versionDirectory) { $candidate = Join-Path (Join-Path $versionDirectory.FullName 'bin') $CommandName }
            }
        }
        if ($candidate -and (Test-Path -LiteralPath $candidate -PathType Leaf)) { return $candidate }
    }
    throw "Could not find $CommandName. Add Android SDK tools to PATH or pass its path explicitly."
}

$script:AndroidSdkRoot = $env:ANDROID_SDK_ROOT
if (-not $script:AndroidSdkRoot) { $script:AndroidSdkRoot = $env:ANDROID_HOME }
if (-not $script:AndroidSdkRoot) {
    $localProperties = Join-Path $PSScriptRoot '..\android\local.properties'
    if (Test-Path -LiteralPath $localProperties -PathType Leaf) {
        $sdkEntry = Get-Content -LiteralPath $localProperties |
            Where-Object { $_ -match '^\s*sdk\.dir\s*=' } |
            Select-Object -First 1
        if ($sdkEntry) {
            $script:AndroidSdkRoot = ($sdkEntry -replace '^\s*sdk\.dir\s*=', '').Trim().Replace('\\', '\')
        }
    }
}

$apk = (Resolve-Path -LiteralPath $ApkPath).Path
if ([IO.Path]::GetExtension($apk) -ne '.apk') { throw 'ApkPath must point to an .apk file.' }

$apkUri = [Uri]::new($BaseApkUrl)
if ($apkUri.Scheme -ne 'https' -or -not $apkUri.Host -or $apkUri.UserInfo -or $apkUri.Query -or $apkUri.Fragment) {
    throw 'BaseApkUrl must be a public HTTPS URL without embedded credentials.'
}

if ($VersionCode -notmatch '^[1-9][0-9]*$') { throw 'VersionCode must be a positive integer.' }
[long]$parsedVersionCode = $VersionCode

$expectedPackages = if ($Channel -eq 'production') {
    @('com.erp.assab')
} else {
    @('com.erp.assab.dev', 'com.erp.assab.dev.debug')
}
$analyzer = Resolve-AndroidTool $ApkAnalyzer 'apkanalyzer.bat' 'cmdline-tools\latest\bin\apkanalyzer.bat'
$signer = Resolve-AndroidTool $ApkSigner 'apksigner.bat' 'build-tools\36.0.0\apksigner.bat'

$actualPackage = (& $analyzer manifest application-id $apk).Trim()
if ($LASTEXITCODE -ne 0) { throw 'apkanalyzer could not read the APK package identity.' }
$actualVersionCode = (& $analyzer manifest version-code $apk).Trim()
if ($LASTEXITCODE -ne 0) { throw 'apkanalyzer could not read the APK versionCode.' }
$actualVersionName = (& $analyzer manifest version-name $apk).Trim()
if ($LASTEXITCODE -ne 0) { throw 'apkanalyzer could not read the APK versionName.' }
if ($actualPackage -notin $expectedPackages) {
    throw "APK package mismatch for $Channel. Expected $($expectedPackages -join ' or '), received $actualPackage."
}
if ([long]$actualVersionCode -ne $parsedVersionCode) { throw "APK versionCode mismatch. Expected $parsedVersionCode, received $actualVersionCode." }
if ($actualVersionName -ne $VersionName) { throw "APK versionName mismatch. Expected '$VersionName', received '$actualVersionName'." }

$verification = & $signer verify --verbose --print-certs $apk 2>&1
if ($LASTEXITCODE -ne 0) { throw "apksigner rejected this APK:`n$verification" }
$certificateLine = $verification | Select-String -Pattern 'Signer #1 certificate SHA-256 digest:' | Select-Object -First 1
if (-not $certificateLine) { throw 'apksigner did not report a signer certificate SHA-256 digest.' }

$fileName = "assab-$Channel-$parsedVersionCode.apk"
$manifestDirectory = Join-Path $OutputDirectory $Channel
New-Item -ItemType Directory -Path $manifestDirectory -Force | Out-Null
$outputApk = Join-Path $manifestDirectory $fileName
if (Test-Path -LiteralPath $outputApk) {
    throw "Prepared APK already exists: $outputApk. Increment versionCode or choose another output directory."
}
Copy-Item -LiteralPath $apk -Destination $outputApk -Force
$resolvedOutputApk = (Resolve-Path -LiteralPath $outputApk).Path
$apkHash = (Get-FileHash -LiteralPath $resolvedOutputApk -Algorithm SHA256).Hash.ToLowerInvariant()
$apkSize = (Get-Item -LiteralPath $resolvedOutputApk).Length
$downloadUrl = $BaseApkUrl.TrimEnd('/') + '/' + $fileName

$manifest = [ordered]@{
    schemaVersion = 1
    channel = $Channel
    packageName = $actualPackage
    versionCode = $parsedVersionCode
    versionName = $VersionName
    apkUrl = $downloadUrl
    sizeBytes = $apkSize
    sha256 = $apkHash
    changelog = [ordered]@{ en = $ChangelogEn; ar = $ChangelogAr }
}
$manifestPath = Join-Path $manifestDirectory 'manifest.json'
$manifestJson = $manifest | ConvertTo-Json -Depth 5
[IO.File]::WriteAllText($manifestPath, $manifestJson, [Text.UTF8Encoding]::new($false))

Write-Host "Prepared $Channel update manifest: $manifestPath"
Write-Host "APK: $resolvedOutputApk"
Write-Host "Package: $actualPackage  Version: $actualVersionName ($actualVersionCode)  Size: $apkSize bytes"
Write-Host "APK signer certificate: $($certificateLine.Line.Trim())"
Write-Host 'Upload the APK and manifest to the configured HTTPS host. Keep channel directories separate.'
