package com.pranta.the_accountant

import android.os.Build
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Android 12+ plays its own exit over the first Flutter frame, sliding
        // and fading the icon. The intro starts as an exact copy of this splash,
        // so that reads as the logo blinking. Removing it outright is invisible.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener { it.remove() }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Google's test devices (Firebase Test Lab, which runs Play's
        // pre-launch report) set this, so the app can keep them out of
        // Analytics.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "the_accountant/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isTestLab" -> result.success(
                        Settings.System.getString(contentResolver, "firebase.test.lab") == "true"
                    )
                    else -> result.notImplemented()
                }
            }
    }
}
