import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    WidgetsFlutterBinding.ensureInitialized();
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'shake_event') {
        print('Shake detected!');
      }
    });
    // RawKeyboard.instance.addListener(_handleRawKeyEvent);
  }

  static const platform = MethodChannel('shake_gesture');

  KeyEventResult _handleRawKeyEvent(RawKeyEvent event) {
    final data = event.data;
    if (data is RawKeyEventDataAndroid && event is RawKeyDownEvent) {
      if (data.keyCode == 82) {
        print("Yahoo");
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleRawKeyEvent,
      child: const MaterialApp(home: HomePage()),
    );
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(),
            OutlinedButton(onPressed: () {}, child: Text("Hello"))
          ],
        ),
      ),
    );
  }
}
