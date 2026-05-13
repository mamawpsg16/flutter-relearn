package com.example.flutter_application_test

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.setDecorFitsSystemWindows(window, false)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Remove the Android 12 fade-out so Flutter takes over without flicker
            splashScreen.setOnExitAnimationListener { view -> view.remove() }
        }

        super.onCreate(savedInstanceState)
    }
}
