$ErrorActionPreference = 'Stop'
$testRoot = Join-Path $PSScriptRoot ('.tmp-update-release-' + [Guid]::NewGuid().ToString('N'))
$testRootAbsolute = [IO.Path]::GetFullPath($testRoot)
$testRootBoundary = [IO.Path]::GetFullPath($PSScriptRoot) + [IO.Path]::DirectorySeparatorChar

function Assert-True {
    param([bool]$Condition, [string]$Message)
    if (-not $Condition) { throw $Message }
}

try {
    New-Item -ItemType Directory -Path $testRootAbsolute -Force | Out-Null
    $apk = Join-Path $testRootAbsolute 'staging-debug.apk'
    $analyzer = Join-Path $testRootAbsolute 'mock-apkanalyzer.cmd'
    $signer = Join-Path $testRootAbsolute 'mock-apksigner.cmd'
    $output = Join-Path $testRootAbsolute 'out'
    [IO.File]::WriteAllBytes($apk, [Text.Encoding]::ASCII.GetBytes('fake signed test apk'))
    @'
@echo off
if "%2"=="application-id" echo %ASSAB_TEST_PACKAGE%
if "%2"=="version-code" echo %ASSAB_TEST_VERSION_CODE%
if "%2"=="version-name" echo %ASSAB_TEST_VERSION_NAME%
exit /b 0
'@ | Set-Content -LiteralPath $analyzer -Encoding ascii
    @'
@echo off
echo Verifies
echo Signer #1 certificate SHA-256 digest: 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
exit /b 0
'@ | Set-Content -LiteralPath $signer -Encoding ascii

    $env:ASSAB_TEST_PACKAGE = 'com.erp.assab.dev.debug'
    $env:ASSAB_TEST_VERSION_CODE = '36'
    $env:ASSAB_TEST_VERSION_NAME = '1.0.1'
    $scriptPath = Join-Path $PSScriptRoot '..\prepare-android-update.ps1'
    & $scriptPath `
        -Channel staging `
        -DistributionTarget self-hosted-apk `
        -ApkPath $apk `
        -BaseApkUrl 'https://updates.assab.example/android/staging' `
        -VersionCode 36 `
        -VersionName '1.0.1' `
        -ChangelogEn 'Test update' `
        -ChangelogAr 'تحديث اختباري' `
        -OutputDirectory $output `
        -ApkAnalyzer $analyzer `
        -ApkSigner $signer | Out-Null

    $manifestPath = Join-Path $output 'staging\manifest.json'
    $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
    Assert-True ($manifest.packageName -eq 'com.erp.assab.dev.debug') 'Staging debug package was not preserved in the manifest.'
    Assert-True ($manifest.versionCode -eq 36) 'Manifest did not retain the APK build number.'
    Assert-True ($manifest.sizeBytes -eq (Get-Item -LiteralPath (Join-Path $output 'staging\assab-staging-36.apk')).Length) 'Manifest APK size does not match the packaged file.'

    $playStoreRejected = $false
    try {
        & $scriptPath `
            -Channel staging `
            -DistributionTarget play-store `
            -ApkPath $apk `
            -BaseApkUrl 'https://updates.assab.example/android/staging' `
            -VersionCode 36 `
            -VersionName '1.0.1' `
            -ChangelogEn 'Test update' `
            -ChangelogAr 'تحديث اختباري' `
            -OutputDirectory $output `
            -ApkAnalyzer $analyzer `
            -ApkSigner $signer | Out-Null
    } catch {
        $playStoreRejected = $_.Exception.Message -match 'only for self-hosted APK distribution'
    }
    Assert-True $playStoreRejected 'Play Store distribution was not blocked by the release script.'

    $env:ASSAB_TEST_PACKAGE = 'com.erp.assab.debug'
    $productionDebugRejected = $false
    try {
        & $scriptPath `
            -Channel production `
            -DistributionTarget self-hosted-apk `
            -ApkPath $apk `
            -BaseApkUrl 'https://updates.assab.example/android/production' `
            -VersionCode 36 `
            -VersionName '1.0.1' `
            -ChangelogEn 'Test update' `
            -ChangelogAr 'تحديث اختباري' `
            -OutputDirectory $output `
            -ApkAnalyzer $analyzer `
            -ApkSigner $signer | Out-Null
    } catch {
        $productionDebugRejected = $_.Exception.Message -match 'APK package mismatch for production'
    }
    Assert-True $productionDebugRejected 'Production debug package was not rejected.'

    Write-Host 'Release preparation smoke tests passed: staging debug accepted, Play Store and production debug rejected.'
} finally {
    Remove-Item Env:ASSAB_TEST_PACKAGE -ErrorAction SilentlyContinue
    Remove-Item Env:ASSAB_TEST_VERSION_CODE -ErrorAction SilentlyContinue
    Remove-Item Env:ASSAB_TEST_VERSION_NAME -ErrorAction SilentlyContinue
    if (Test-Path -LiteralPath $testRootAbsolute) {
        if (-not $testRootAbsolute.StartsWith($testRootBoundary, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Refusing to remove test directory outside the test folder: $testRootAbsolute"
        }
        Remove-Item -LiteralPath $testRootAbsolute -Recurse -Force
    }
}
