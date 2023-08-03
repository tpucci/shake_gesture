import 'package:flutter/services.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

/// An implementation of [ShakeGesturePlatform] that uses method channels.
class MethodChannelShakeGesture extends ShakeGesturePlatform {
  /// The method channel used to interact with the native platform.
  final methodChannel = const MethodChannel('shake_gesture');
}
