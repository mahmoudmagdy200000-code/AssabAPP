package com.erp.assab

import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.content.pm.PackageInstaller
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.security.MessageDigest
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors

private data class ApkSignerInfo(
    val current: Set<String>,
    val history: Set<String>,
    val hasMultipleSigners: Boolean,
)

class MainActivity : FlutterActivity() {
    private val updateChannel = "com.erp.assab/in_app_updates"
    private val updateExecutor = Executors.newSingleThreadExecutor { task ->
        Thread(task, "assab-apk-update").apply { isDaemon = true }
    }
    private val verifiedApks = ConcurrentHashMap<String, String>()

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        installSplashScreen()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, updateChannel)
            .setMethodCallHandler { call, result ->
                try {
                    when (call.method) {
                        "getConfiguration" -> result.success(configuration())
                        "verifyApk" -> {
                            val path = call.argument<String>("path")
                                ?: throw IllegalArgumentException("APK path is missing")
                            val expectedSha256 = call.argument<String>("sha256")
                                ?: throw IllegalArgumentException("APK checksum is missing")
                            runUpdateWork(result) { verifyApk(path, expectedSha256) }
                        }
                        "installApk" -> {
                            val path = call.argument<String>("path")
                                ?: throw IllegalArgumentException("APK path is missing")
                            val expectedSha256 = call.argument<String>("sha256")
                                ?: throw IllegalArgumentException("APK checksum is missing")
                            runUpdateWork(result) {
                                installApk(path, expectedSha256)
                                true
                            }
                        }
                        else -> result.notImplemented()
                    }
                } catch (error: Exception) {
                    result.error("UPDATE_${error.javaClass.simpleName.uppercase()}", error.message, null)
                }
            }
    }

    private fun runUpdateWork(result: MethodChannel.Result, work: () -> Any) {
        updateExecutor.execute {
            try {
                val value = work()
                runOnUiThread { result.success(value) }
            } catch (error: Exception) {
                runOnUiThread {
                    result.error(
                        "UPDATE_${error.javaClass.simpleName.uppercase()}",
                        error.message,
                        null,
                    )
                }
            }
        }
    }

    private fun configuration(): Map<String, Any> {
        val info = getInstalledPackageInfo(0)
        val playStoreManaged = isInstalledFromPlayStore()
        val packageAllowed = UpdateSecurityPolicy.isPackageAllowed(
            BuildConfig.UPDATE_CHANNEL,
            packageName,
        )
        return mapOf(
            "channel" to BuildConfig.UPDATE_CHANNEL,
            "manifestUrl" to BuildConfig.UPDATE_MANIFEST_URL,
            "packageName" to packageName,
            "versionCode" to releaseVersionCode(info),
            "versionName" to (info.versionName ?: ""),
            "playStoreManaged" to playStoreManaged,
            "distributionAllowed" to (!playStoreManaged && packageAllowed),
        )
    }

    private fun isInstalledFromPlayStore(): Boolean {
        val installerPackages = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val source = packageManager.getInstallSourceInfo(packageName)
            setOfNotNull(
                source.installingPackageName,
                source.initiatingPackageName,
                source.originatingPackageName,
            )
        } else {
            @Suppress("DEPRECATION")
            setOfNotNull(packageManager.getInstallerPackageName(packageName))
        }
        return installerPackages.any(UpdateSecurityPolicy::isPlayStoreInstaller)
    }

    private fun verifyApk(path: String, expectedSha256: String): Map<String, Any> {
        require(expectedSha256.matches(Regex("[a-fA-F0-9]{64}"))) { "Invalid SHA-256 checksum" }
        val apk = updateCacheFile(path)
        verifiedApks.remove(apk.path)
        val actualSha256 = FileInputStream(apk).use { UpdateSecurityPolicy.sha256(it) }
        require(actualSha256.equals(expectedSha256, ignoreCase = true)) {
            "APK checksum mismatch"
        }

        val archiveInfo = getArchivePackageInfo(apk)
            ?: throw IllegalArgumentException("Downloaded file is not a valid Android APK")
        require(archiveInfo.packageName == packageName) { "APK package does not match this app" }
        require(releaseVersionCode(archiveInfo) > releaseVersionCode(getInstalledPackageInfo(0))) {
            "APK version is not newer than the installed app"
        }

        val installedSignerInfo = signerInfo(getInstalledPackageInfo(signingFlags()))
        val candidateSignerInfo = signerInfo(archiveInfo)
        require(
            UpdateSecurityPolicy.hasCompatibleSigners(
                installedSigners = installedSignerInfo.current,
                installedHasMultipleSigners = installedSignerInfo.hasMultipleSigners,
                candidateSigners = candidateSignerInfo.current,
                candidateHistory = candidateSignerInfo.history,
                candidateHasMultipleSigners = candidateSignerInfo.hasMultipleSigners,
            ),
        ) { "APK signing certificate is incompatible with the installed app" }

        verifiedApks[apk.path] = actualSha256
        return mapOf(
            "packageName" to archiveInfo.packageName,
            "versionCode" to releaseVersionCode(archiveInfo),
            "versionName" to (archiveInfo.versionName ?: ""),
            "sha256" to actualSha256,
            "signingCompatible" to true,
        )
    }

    private fun installApk(path: String, expectedSha256: String) {
        val apk = updateCacheFile(path)
        val verifiedSha256 = verifiedApks.remove(apk.path)
            ?: throw SecurityException("APK must be verified before installer handoff")
        require(verifiedSha256.equals(expectedSha256, ignoreCase = true)) {
            "Installer checksum does not match the verified APK"
        }
        require(apk.length() > 0L) { "Verified APK is empty" }

        val params = PackageInstaller.SessionParams(PackageInstaller.SessionParams.MODE_FULL_INSTALL)
            .apply {
                setAppPackageName(packageName)
                setSize(apk.length())
            }
        val installer = packageManager.packageInstaller
        val sessionId = installer.createSession(params)
        var session: PackageInstaller.Session? = null
        try {
            val openSession = installer.openSession(sessionId)
            session = openSession
            openSession.openWrite("assab-update.apk", 0, apk.length()).use { destination ->
                FileInputStream(apk).use { source ->
                    val copiedBytes = UpdateSecurityPolicy.copyVerifiedApk(
                        input = source,
                        output = destination,
                        expectedSha256 = verifiedSha256,
                    )
                    require(copiedBytes == apk.length()) {
                        "APK changed while it was staged for installation"
                    }
                }
                openSession.fsync(destination)
            }

            val statusIntent = Intent(this, UpdateInstallStatusReceiver::class.java)
                .setAction("com.erp.assab.UPDATE_INSTALL_STATUS.$sessionId")
            var pendingIntentFlags = PendingIntent.FLAG_UPDATE_CURRENT
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                pendingIntentFlags = pendingIntentFlags or PendingIntent.FLAG_MUTABLE
            }
            val statusReceiver = PendingIntent.getBroadcast(
                this,
                sessionId,
                statusIntent,
                pendingIntentFlags,
            )
            openSession.commit(statusReceiver.intentSender)
        } catch (error: Exception) {
            session?.abandon()
            throw error
        } finally {
            session?.close()
        }
    }

    private fun updateCacheFile(path: String): File {
        val apk = File(path).canonicalFile
        val allowedDirectory = File(cacheDir, "update-downloads").canonicalFile
        require(apk.path.startsWith(allowedDirectory.path + File.separator) && apk.isFile) {
            "APK is outside the update cache or missing"
        }
        return apk
    }

    private fun signingFlags(): Int = UpdateSecurityPolicy.signingFlags(
        Build.VERSION.SDK_INT,
        PackageManager.GET_SIGNATURES,
        PackageManager.GET_SIGNING_CERTIFICATES,
    )

    @Suppress("DEPRECATION")
    private fun getInstalledPackageInfo(flags: Int): PackageInfo =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.getPackageInfo(packageName, PackageManager.PackageInfoFlags.of(flags.toLong()))
        } else {
            packageManager.getPackageInfo(packageName, flags)
        }

    @Suppress("DEPRECATION")
    private fun getArchivePackageInfo(apk: File): PackageInfo? {
        val flags = signingFlags()
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.getPackageArchiveInfo(
                apk.path,
                PackageManager.PackageInfoFlags.of(flags.toLong()),
            )
        } else {
            packageManager.getPackageArchiveInfo(apk.path, flags)
        }
    }

    @Suppress("DEPRECATION")
    private fun signerInfo(info: PackageInfo): ApkSignerInfo {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val signingInfo = info.signingInfo
                ?: throw SecurityException("APK signing information is unavailable")
            val current = signingInfo.apkContentsSigners.map(::certificateFingerprint).toSet()
            val history = signingInfo.signingCertificateHistory.map(::certificateFingerprint).toSet()
            return ApkSignerInfo(current, history, signingInfo.hasMultipleSigners())
        }

        val current = info.signatures.orEmpty().map(::certificateFingerprint).toSet()
        return ApkSignerInfo(current, current, current.size > 1)
    }

    private fun certificateFingerprint(signature: android.content.pm.Signature): String =
        MessageDigest.getInstance("SHA-256").digest(signature.toByteArray())
            .joinToString("") { "%02x".format(it) }

    @Suppress("DEPRECATION")
    private fun releaseVersionCode(info: PackageInfo): Long =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) info.longVersionCode
        else info.versionCode.toLong()
}
