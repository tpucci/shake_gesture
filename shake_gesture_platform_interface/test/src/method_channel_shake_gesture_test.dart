import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture_platform_interface/src/method_channel_shake_gesture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelShakeGesture', () {
    late MethodChannelShakeGesture methodChannelShakeGesture;
    final log = <MethodCall>[];

    setUp(() async {
      methodChannelShakeGesture = MethodChannelShakeGesture();
    });

    tearDown(log.clear);
  });
}
