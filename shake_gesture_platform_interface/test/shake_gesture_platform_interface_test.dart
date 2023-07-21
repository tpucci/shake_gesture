import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

class ShakeGestureMock extends ShakeGesturePlatform {
  static const mockPlatformName = 'Mock';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('ShakeGesturePlatformInterface', () {
    late ShakeGesturePlatform shakeGesturePlatform;

    setUp(() {
      shakeGesturePlatform = ShakeGestureMock();
      ShakeGesturePlatform.instance = shakeGesturePlatform;
    });
  });
}
