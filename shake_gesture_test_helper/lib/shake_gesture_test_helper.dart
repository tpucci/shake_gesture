import 'package:flutter_test/flutter_test.dart';
import 'shake_gesture_test_helper_platform_interface.dart';

extension ShakeGestureTestHelperExtension on WidgetTester {
  static Future<void> simulateShake() async {
    await ShakeGestureTestHelperPlatform.instance.shake();
  }

  Future<void> shake() async {
    await ShakeGestureTestHelperPlatform.instance.shake();
  }
}
