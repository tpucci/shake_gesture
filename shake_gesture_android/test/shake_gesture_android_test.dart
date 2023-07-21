import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_android/shake_gesture_android.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShakeGestureAndroid', () {
    const kPlatformName = 'Android';
    late ShakeGestureAndroid shakeGesture;
    late List<MethodCall> log;

    setUp(() async {
      shakeGesture = ShakeGestureAndroid();

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
      ShakeGestureAndroid.registerWith();
      expect(ShakeGesturePlatform.instance, isA<ShakeGestureAndroid>());
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
