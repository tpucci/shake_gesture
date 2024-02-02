# shake_gesture

This Flutter plugin detects shake gestures on Android and iOS.

## Usage

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShakeGesture Example')),
      body: Center(

		// Here it is 👇

        child: ShakeGesture(
          onShake: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shake!')),
            );
          },
          child: const Center(
            child: OutlinedButton(
              onPressed: ShakeGestureTestHelperExtension.simulateShake,
              child: Text('Simulate Shake'),
            ),
          ),
        ),

		// The end.

      ),
    );
  }
}
```

## Simulator

This package works in the iOS simulator.

To simulate a shake event in Android emulator, either play with the Sensor Manager, or add the following piece of code to your Activity:

```kotlin
class MainActivity: FlutterActivity() {

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            this.flutterEngine?.plugins?.get(ShakeGesturePlugin::class.java).let { plugin ->
                if (plugin is ShakeGesturePlugin)
                    plugin.onShake()
            }
        }

        return super.onKeyDown(keyCode, event)
    }

}
```

Then, you can use ctrl+m or cmd+m (mac) to simulate a shake motion.

## Test Helper

In order to simulate a shake gesture in a test, add the following package:

`shake_gesture_test_helper`

And call the `shake` method on your `widgetTester`:

```dart
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
```

## Customize required shake gesture

### iOS

Unfortunatly, you can not customize the shake gesture on iOS.
Indeed, this package depends on the Apple SDK's [`motionShake`](https://developer.apple.com/documentation/uikit/uievent/eventsubtype/motionshake).

### Android

By default, the required shake force is `6 Newtons` and the required number of shakes is `6`.
This can be overriden in your `AndroidManifest.xml` file:

```xml
<manifest ...>
    <application ...>
        <meta-data
            android:name="dev.fluttercommunity.shake_gesture_android.SHAKE_FORCE"
            android:value="4" />
        <meta-data
            android:name="dev.fluttercommunity.shake_gesture_android.MIN_NUM_SHAKES"
            android:value="3" />
    </application>
</manifest>
```

## Contribute

Test your contribution by running the unit tests and integration tests.

```sh
cd shake_gesture/example
flutter test
flutter test integration_test
```
