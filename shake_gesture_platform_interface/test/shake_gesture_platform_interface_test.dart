import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

class ShakeGestureMock extends ShakeGesturePlatform {
  static const mockPlatformName = 'Mock';

  @override
  Future<String?> getPlatformName() async => mockPlatformName;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ShakeGesturePlatformInterface', () {
    late ShakeGesturePlatform shakeGesturePlatform;

    setUp(() {
      shakeGesturePlatform = ShakeGestureMock();
      ShakeGesturePlatform.instance = shakeGesturePlatform;
    });

    group('getPlatformName', () {
      test('returns correct name', () async {
        expect(
          await ShakeGesturePlatform.instance.getPlatformName(),
          equals(ShakeGestureMock.mockPlatformName),
        );
      });
    });
  });
}
