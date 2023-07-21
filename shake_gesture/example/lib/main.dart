import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shake_gesture/shake_gesture.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    WidgetsFlutterBinding.ensureInitialized();
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'shake_event') {
        print('Shake detected!');
      }
    });
  }

  static const platform = MethodChannel('shake_gesture_ios');

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ShakeGesture Example')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [],
        ),
      ),
    );
  }
}
