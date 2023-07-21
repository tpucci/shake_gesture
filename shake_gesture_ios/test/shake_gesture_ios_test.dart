import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_ios/shake_gesture_ios.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShakeGestureIOS', () {
    late ShakeGestureIOS shakeGesture;
    late List<MethodCall> log;

    setUp(() async {
      shakeGesture = ShakeGestureIOS();

      log = <MethodCall>[];
    });

    test('can be registered', () {
      ShakeGestureIOS.registerWith();
      expect(ShakeGesturePlatform.instance, isA<ShakeGestureIOS>());
    });
  });
}
