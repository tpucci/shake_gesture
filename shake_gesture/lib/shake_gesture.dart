import 'package:flutter/widgets.dart';
import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

ShakeGesturePlatform get _platform => ShakeGesturePlatform.instance;

/// A widget that detects shake gestures.
class ShakeGesture extends StatefulWidget {
  /// Creates a widget that detects shake gestures.
  /// [child] is the widget that will be rendered.
  const ShakeGesture({required this.child, required this.onShake, super.key})
      : super();

  /// The widget that will be rendered.
  final Widget child;

  /// The callback that will be called when a shake gesture is detected.
  final VoidCallback onShake;

  @override
  State<ShakeGesture> createState() => _ShakeGestureState();
}

class _ShakeGestureState extends State<ShakeGesture> {
  @override
  void initState() {
    super.initState();
    _platform.registerCallback(onShake: widget.onShake);
  }

  @override
  void dispose() {
    _platform.unregisterCallback(onShake: widget.onShake);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
