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
  });
}
