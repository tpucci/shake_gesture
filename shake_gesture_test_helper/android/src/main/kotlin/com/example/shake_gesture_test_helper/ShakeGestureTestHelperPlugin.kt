package com.example.shake_gesture_test_helper

import android.hardware.SensorManager
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import shake_gesture_android.ShakeGesturePlugin

/** ShakeGestureTestHelperPlugin */
class ShakeGestureTestHelperPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private val RAGE_SHAKE = SensorManager.GRAVITY_EARTH * 1.5f

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "shake_gesture_test_helper")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "shake") {
            shake()
            result.success(null)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun shake() {
        ShakeGesturePlugin.shakeDetector?.let { shakeDetector ->
            for (i in 1..6) {
                val direction = if (i % 2 == 0) 1 else -1
                shakeDetector.processAccelerationData(direction * RAGE_SHAKE, 0f, 0f)
            }
        }
    }
}
