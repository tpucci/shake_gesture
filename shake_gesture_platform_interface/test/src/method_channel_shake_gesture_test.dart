import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_platform_interface/src/method_channel_shake_gesture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const kPlatformName = 'platformName';

  group('$MethodChannelShakeGesture', () {
    late MethodChannelShakeGesture methodChannelShakeGesture;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelShakeGesture = MethodChannelShakeGesture();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelShakeGesture.methodChannel,
        (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'getPlatformName':
              return kPlatformName;
            default:
              return null;
          }
        },
      );
    });

    tearDown(log.clear);

    test('getPlatformName', () async {
      final platformName = await methodChannelShakeGesture.getPlatformName();
      expect(
        log,
        <Matcher>[isMethodCall('getPlatformName', arguments: null)],
      );
      expect(platformName, equals(kPlatformName));
    });
  });
}
