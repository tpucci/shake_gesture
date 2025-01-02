import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:shake_gesture_test_helper/shake_gesture_test_helper.dart';

void main() {
  group('ShakeGesture', () {
    testWidgets('it detects shakes', (widgetTester) async {
      var shakeDetected = false;
      await widgetTester.pumpWidget(
        ShakeGesture(
          onShake: () {
            shakeDetected = true;
          },
          child: Container(),
        ),
      );
      await widgetTester.shake();
      expect(shakeDetected, true);
    });

    testWidgets('it detects shakes imperatively', (widgetTester) async {
      var shakeDetected = 0;
      void onShake() {
        shakeDetected += 1;
      }

      ShakeGesture.registerCallback(
        onShake: onShake,
      );
      await widgetTester.shake();
      ShakeGesture.unregisterCallback(
        onShake: onShake,
      );
      await widgetTester.shake();
      expect(shakeDetected, 1);
    });
  });
}
