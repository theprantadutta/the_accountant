package com.pranta.the_accountant

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

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
}
