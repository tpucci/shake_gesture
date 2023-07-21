import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_ios/shake_gesture_ios.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShakeGestureIOS', () {
    const kPlatformName = 'iOS';
    late ShakeGestureIOS shakeGesture;
    late List<MethodCall> log;

    setUp(() async {
      shakeGesture = ShakeGestureIOS();

      log = <MethodCall>[];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(shakeGesture.methodChannel, (methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getPlatformName':
            return kPlatformName;
          default:
            return null;
        }
      });
    });

    test('can be registered', () {
      ShakeGestureIOS.registerWith();
      expect(ShakeGesturePlatform.instance, isA<ShakeGestureIOS>());
    });

    test('getPlatformName returns correct name', () async {
      final name = await shakeGesture.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(name, equals(kPlatformName));
    });
  });
}
