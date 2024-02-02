package dev.fluttercommunity.shake_gesture_android

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.LifecycleOwner
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class ShakeGesturePlugin: FlutterPlugin, MethodCallHandler, ShakeDetector.OnShakeListener, ActivityAware, DefaultLifecycleObserver {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel

    companion object {
        var shakeDetector: ShakeDetector? = null
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "shake_gesture")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        // Not used
    }

    override fun onShake() {
        channel.invokeMethod("onShake", null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        shakeDetector = ShakeDetector(binding.activity, this)
        shakeDetector?.start()
        if (binding.lifecycle is HiddenLifecycleReference) {
            val hiddenLifecycleReference = binding.lifecycle as HiddenLifecycleReference
            hiddenLifecycleReference.lifecycle.addObserver(this)
        }
    }

    override fun onPause(owner: LifecycleOwner) {
        super.onPause(owner)
        shakeDetector?.stop()
    }

    override fun onResume(owner: LifecycleOwner) {
        super.onResume(owner)
        shakeDetector?.start()
    }

    override fun onDetachedFromActivityForConfigChanges() {
        shakeDetector?.stop()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        shakeDetector?.start()
    }

    override fun onDetachedFromActivity() {
        shakeDetector?.stop()
    }
}
