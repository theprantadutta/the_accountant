## Google ML Kit - Text Recognition
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-dontwarn com.google.mlkit.vision.text.**

## Play Billing, via flutter_inapp_purchase (OpenIAP)
-keep class dev.hyo.** { *; }
-keep class io.github.hyochan.** { *; }
-keep class com.android.vending.billing.**
-keep class com.android.billingclient.** { *; }
-dontwarn dev.hyo.**
-dontwarn io.github.hyochan.**
