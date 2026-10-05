# ========================
# Flutter wrapper code (Android side)
# ========================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# ========================
# Retrofit + OkHttp + Dio
# ========================
-keepattributes Signature
-keepattributes *Annotation*
-keep class retrofit2.** { *; }
-dontwarn retrofit2.**
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**
-keep class okio.** { *; }
-dontwarn okio.**

# If using Gson / JSON serialization (from Retrofit)
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
# The following line is only needed if your Android code uses Gson reflection.
# -keep class * {
#     @com.google.gson.annotations.SerializedName <fields>;
# }


# ========================
# Firebase
# ========================
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# ========================
# Flutter Secure Storage
# ========================
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.it_nomads.fluttersecurestorage.**

# ========================
# Permission Handler (Android plugin)
# ========================
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# ========================
# Image Picker (Android plugin)
# ========================
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# ========================
# Local Notifications (Android plugin)
# ========================
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# ========================
# Misc safe defaults
# ========================
-dontwarn javax.annotation.**
-keepclassmembers enum * { *; }
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# SLF4J fix
-keep class org.slf4j.** { *; }
-dontwarn org.slf4j.**