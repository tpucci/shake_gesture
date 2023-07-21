package shake_gesture_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ShakeGesturePlugin: FlutterPlugin, MethodCallHandler, ShakeDetector.OnShakeListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel : MethodChannel
    private lateinit var shakeDetector: ShakeDetector


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "shake")
        channel.setMethodCallHandler(this)
        shakeDetector = ShakeDetector(flutterPluginBinding.applicationContext, this)
        shakeDetector.start()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        shakeDetector.stop()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        // Not used
    }

    override fun onShake() {
        channel.invokeMethod("shake_event", null)
    }
}
