package com.erp.assab

import java.io.InputStream
import java.io.OutputStream
import java.security.MessageDigest

internal object UpdateSecurityPolicy {
    private const val PLAY_STORE_PACKAGE = "com.android.vending"

    fun signingFlags(sdkInt: Int, legacyFlag: Int, currentFlag: Int): Int =
        if (sdkInt >= 28) currentFlag else legacyFlag

    fun hasCompatibleSigners(
        installedSigners: Set<String>,
        installedHasMultipleSigners: Boolean,
        candidateSigners: Set<String>,
        candidateHistory: Set<String>,
        candidateHasMultipleSigners: Boolean,
    ): Boolean {
        if (installedSigners.isEmpty() || candidateSigners.isEmpty()) return false
        if (installedSigners == candidateSigners) return true
        if (installedHasMultipleSigners || candidateHasMultipleSigners) return false
        if (installedSigners.size != 1 || candidateSigners.size != 1) return false

        val installedCurrentSigner = installedSigners.single()
        return candidateHistory.contains(installedCurrentSigner) &&
            candidateHistory.containsAll(candidateSigners)
    }

    fun isPlayStoreInstaller(installerPackage: String?): Boolean =
        installerPackage == PLAY_STORE_PACKAGE

    fun isPackageAllowed(channel: String, packageName: String): Boolean = when (channel) {
        "production" -> packageName == "com.erp.assab"
        "staging" -> packageName == "com.erp.assab.dev" ||
            packageName == "com.erp.assab.dev.debug"
        else -> false
    }

    fun copyVerifiedApk(
        input: InputStream,
        output: OutputStream,
        expectedSha256: String,
    ): Long {
        require(expectedSha256.matches(Regex("[a-fA-F0-9]{64}"))) {
            "Invalid expected APK SHA-256"
        }
        val digest = MessageDigest.getInstance("SHA-256")
        val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
        var totalBytes = 0L
        while (true) {
            val count = input.read(buffer)
            if (count < 0) break
            digest.update(buffer, 0, count)
            output.write(buffer, 0, count)
            totalBytes += count
        }
        val actualSha256 = digest.digest().joinToString("") { "%02x".format(it) }
        if (!actualSha256.equals(expectedSha256, ignoreCase = true)) {
            throw SecurityException("APK bytes changed after verification")
        }
        return totalBytes
    }

    fun sha256(input: InputStream): String {
        val digest = MessageDigest.getInstance("SHA-256")
        input.use { stream ->
            val buffer = ByteArray(DEFAULT_BUFFER_SIZE)
            while (true) {
                val count = stream.read(buffer)
                if (count < 0) break
                digest.update(buffer, 0, count)
            }
        }
        return digest.digest().joinToString("") { "%02x".format(it) }
    }
}
