import 'package:flutter/material.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:shake_gesture_test_helper/shake_gesture_test_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShakeGesture Example')),
      body: Center(
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
      ),
    );
  }
}
