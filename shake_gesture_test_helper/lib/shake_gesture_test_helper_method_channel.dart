import 'package:flutter/services.dart';

import 'shake_gesture_test_helper_platform_interface.dart';

/// An implementation of [ShakeGestureTestHelperPlatform] that uses method channels.
class MethodChannelShakeGestureTestHelper
    extends ShakeGestureTestHelperPlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('shake_gesture_test_helper');

  @override
  Future<void> shake() async {
    await methodChannel.invokeMethod<String>('shake');
    await Future.delayed(const Duration(milliseconds: 10));
  }
}
