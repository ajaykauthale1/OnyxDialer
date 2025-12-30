# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep our entry points (Manifest referenced)
-keep class com.daithan.stealthdialer.MainActivity { *; }
-keep class com.daithan.stealthdialer.StealthCallService { *; }
-keep class com.daithan.stealthdialer.PublicCallActivity { *; }

# Keep CallManager as it is a singleton accessed by Service and Activity
-keep class com.daithan.stealthdialer.CallManager { *; }

# Allow obfuscation of internal logic
