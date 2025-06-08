# Keep all Sceneform classes
-keep class com.google.ar.sceneform.** { *; }
-keep class com.google.devtools.build.android.desugar.runtime.** { *; }
-dontwarn com.google.ar.sceneform.**

# Needed for reflection
-keepclassmembers class * {
    @com.google.ar.sceneform.** *;
}