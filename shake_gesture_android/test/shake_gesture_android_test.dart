import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_android/shake_gesture_android.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShakeGestureAndroid', () {
    late ShakeGestureAndroid shakeGesture;
    late List<MethodCall> log;

    setUp(() async {
      shakeGesture = ShakeGestureAndroid();

      log = <MethodCall>[];
    });

    test('can be registered', () {
      ShakeGestureAndroid.registerWith();
      expect(ShakeGesturePlatform.instance, isA<ShakeGestureAndroid>());
    });
  });
}
