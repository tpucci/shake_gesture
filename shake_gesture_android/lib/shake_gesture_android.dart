import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

/// The Android implementation of [ShakeGesturePlatform].
class ShakeGestureAndroid extends ShakeGesturePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shake_gesture_android');

  /// Registers this class as the default instance of [ShakeGesturePlatform]
  static void registerWith() {
    ShakeGesturePlatform.instance = ShakeGestureAndroid();
  }

  @override
  Future<String?> getPlatformName() {
    return methodChannel.invokeMethod<String>('getPlatformName');
  }
}
