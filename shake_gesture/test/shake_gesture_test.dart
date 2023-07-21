import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

class MockShakeGesturePlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ShakeGesturePlatform {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ShakeGesture', () {
    late ShakeGesturePlatform shakeGesturePlatform;

    setUp(() {
      shakeGesturePlatform = MockShakeGesturePlatform();
      ShakeGesturePlatform.instance = shakeGesturePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name when platform implementation exists',
          () async {
        const platformName = '__test_platform__';
        when(
          () => shakeGesturePlatform.getPlatformName(),
        ).thenAnswer((_) async => platformName);

        final actualPlatformName = await getPlatformName();
        expect(actualPlatformName, equals(platformName));
      });

      test('throws exception when platform implementation is missing',
          () async {
        when(
          () => shakeGesturePlatform.getPlatformName(),
        ).thenAnswer((_) async => null);

        expect(getPlatformName, throwsException);
      });
    });
  });
}
