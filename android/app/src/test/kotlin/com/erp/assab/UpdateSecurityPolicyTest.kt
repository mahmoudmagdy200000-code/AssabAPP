package com.erp.assab

import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream

class UpdateSecurityPolicyTest {
    @Test
    fun `uses legacy and signing certificate flags across Android API 28 boundary`() {
        assertEquals(64, UpdateSecurityPolicy.signingFlags(27, 64, 134217728))
        assertEquals(134217728, UpdateSecurityPolicy.signingFlags(28, 64, 134217728))
        assertEquals(134217728, UpdateSecurityPolicy.signingFlags(33, 64, 134217728))
    }

    @Test
    fun `allows only exact signers or a declared single-signer rotation lineage`() {
        assertTrue(
            UpdateSecurityPolicy.hasCompatibleSigners(
                installedSigners = setOf("old"),
                installedHasMultipleSigners = false,
                candidateSigners = setOf("new"),
                candidateHistory = setOf("old", "new"),
                candidateHasMultipleSigners = false,
            ),
        )
        assertFalse(
            UpdateSecurityPolicy.hasCompatibleSigners(
                installedSigners = setOf("old"),
                installedHasMultipleSigners = false,
                candidateSigners = setOf("new"),
                candidateHistory = setOf("new"),
                candidateHasMultipleSigners = false,
            ),
        )
        assertFalse(
            UpdateSecurityPolicy.hasCompatibleSigners(
                installedSigners = setOf("old"),
                installedHasMultipleSigners = false,
                candidateSigners = setOf("new"),
                candidateHistory = setOf("old", "new"),
                candidateHasMultipleSigners = true,
            ),
        )
        assertTrue(
            UpdateSecurityPolicy.hasCompatibleSigners(
                installedSigners = setOf("one", "two"),
                installedHasMultipleSigners = true,
                candidateSigners = setOf("two", "one"),
                candidateHistory = emptySet(),
                candidateHasMultipleSigners = true,
            ),
        )
    }

    @Test
    fun `blocks Play Store installs while allowing unknown sideload sources`() {
        assertTrue(UpdateSecurityPolicy.isPlayStoreInstaller("com.android.vending"))
        assertFalse(UpdateSecurityPolicy.isPlayStoreInstaller(null))
        assertFalse(UpdateSecurityPolicy.isPlayStoreInstaller("com.android.packageinstaller"))
    }

    @Test
    fun `authorizes staging debug package without admitting production debug`() {
        assertTrue(UpdateSecurityPolicy.isPackageAllowed("staging", "com.erp.assab.dev"))
        assertTrue(UpdateSecurityPolicy.isPackageAllowed("staging", "com.erp.assab.dev.debug"))
        assertFalse(UpdateSecurityPolicy.isPackageAllowed("production", "com.erp.assab.debug"))
        assertFalse(UpdateSecurityPolicy.isPackageAllowed("production", "com.erp.assab.dev.debug"))
    }

    @Test
    fun `streams exactly the bytes matching the expected checksum`() {
        val output = ByteArrayOutputStream()
        val copied = UpdateSecurityPolicy.copyVerifiedApk(
            input = ByteArrayInputStream("abc".toByteArray()),
            output = output,
            expectedSha256 = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
        )

        assertEquals(3L, copied)
        assertArrayEquals("abc".toByteArray(), output.toByteArray())
    }

    @Test(expected = SecurityException::class)
    fun `rejects streamed bytes changed after the initial verification`() {
        UpdateSecurityPolicy.copyVerifiedApk(
            input = ByteArrayInputStream("tampered".toByteArray()),
            output = ByteArrayOutputStream(),
            expectedSha256 = "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
        )
    }
}
