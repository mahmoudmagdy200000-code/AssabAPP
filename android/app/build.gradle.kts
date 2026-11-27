import java.io.FileInputStream
import java.net.URI
import java.util.Properties

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") apply false
    id("com.google.firebase.crashlytics") apply false
}

// Only apply Google Services / Crashlytics when a real Firebase configuration file exists
// and we are not building the standalone Shift Demo flavor.
val isShiftDemo = gradle.startParameter.taskNames.any { it.contains("Demo", ignoreCase = true) }
val hasGoogleServicesConfig = file("google-services.json").exists() ||
    file("src/development/google-services.json").exists() ||
    file("src/production/google-services.json").exists()
if (!isShiftDemo && hasGoogleServicesConfig) {
    apply(plugin = "com.google.gms.google-services")
    apply(plugin = "com.google.firebase.crashlytics")
}

val keyPropertiesFile = rootProject.file("key.properties")
val keyProperties = Properties().apply {
    if (keyPropertiesFile.exists()) {
        load(FileInputStream(keyPropertiesFile))
    }
}

fun String.asBuildConfigString(): String = "\"${replace("\\", "\\\\").replace("\"", "\\\"")}\""

val productionUpdateManifestUrl = providers.environmentVariable("ASSAB_PRODUCTION_UPDATE_MANIFEST_URL").orElse("").get()
val stagingUpdateManifestUrl = providers.environmentVariable("ASSAB_STAGING_UPDATE_MANIFEST_URL").orElse("").get()

fun validateUpdateManifestUrl(channel: String, value: String) {
    if (value.isEmpty()) return
    val uri = runCatching { URI(value) }.getOrElse {
        throw GradleException("Invalid ASSAB $channel update manifest URL", it)
    }
    if (uri.scheme != "https" || uri.host.isNullOrBlank() || uri.userInfo != null) {
        throw GradleException("ASSAB $channel update manifest URL must use HTTPS without credentials")
    }
}

validateUpdateManifestUrl("Production", productionUpdateManifestUrl)
validateUpdateManifestUrl("Staging", stagingUpdateManifestUrl)

android {
    namespace = "com.erp.assab"
    buildFeatures {
        buildConfig = true
    }
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    signingConfigs {
        create("release") {
            if (keyPropertiesFile.exists()) {
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
                storeFile = file(keyProperties.getProperty("storeFile"))
                storePassword = keyProperties.getProperty("storePassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.erp.assab"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("debug") {
            applicationIdSuffix = ".debug"
            isDebuggable = true
        }
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    flavorDimensions += listOf("env")
    productFlavors {
        create("demo") {
            dimension = "env"
            applicationIdSuffix = ".shiftdemo"
            resValue("string", "app_name", "Assab Shift Demo")
            buildConfigField("String", "UPDATE_CHANNEL", "\"disabled\"")
            buildConfigField("String", "UPDATE_MANIFEST_URL", "\"\"")
        }
        create("development") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Assap Dev")
            buildConfigField("String", "UPDATE_CHANNEL", "\"staging\"")
            buildConfigField("String", "UPDATE_MANIFEST_URL", stagingUpdateManifestUrl.asBuildConfigString())
        }
        create("production") {
            dimension = "env"
            resValue("string", "app_name", "Assap")
            buildConfigField("String", "UPDATE_CHANNEL", "\"production\"")
            buildConfigField("String", "UPDATE_MANIFEST_URL", productionUpdateManifestUrl.asBuildConfigString())
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8:1.9.22")
    implementation("androidx.core:core-splashscreen:1.2.0")
    implementation("org.slf4j:slf4j-nop:1.7.36")
    testImplementation("junit:junit:4.13.2")
}

flutter {
    source = "../.."
}
