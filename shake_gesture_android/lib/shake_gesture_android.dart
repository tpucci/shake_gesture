import 'package:flutter/services.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

/// The Android implementation of [ShakeGesturePlatform].
class ShakeGestureAndroid extends ShakeGesturePlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('shake_gesture');

  /// Registers this class as the default instance of [ShakeGesturePlatform]
  static void registerWith() {
    ShakeGesturePlatform.instance = ShakeGestureAndroid();
  }

  var _initialized = false;

  void _init() {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'onShake':
          onShake();
      }
    });
    _initialized = true;
  }

  @override
  void registerCallback({required VoidCallback onShake}) {
    if (!_initialized) {
      _init();
    }
    super.registerCallback(onShake: onShake);
  }
}
