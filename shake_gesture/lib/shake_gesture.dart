import 'package:shake_gesture_platform_interface/shake_gesture_platform_interface.dart';

ShakeGesturePlatform get _platform => ShakeGesturePlatform.instance;

/// Returns the name of the current platform.
Future<String> getPlatformName() async {
  final platformName = await _platform.getPlatformName();
  if (platformName == null) throw Exception('Unable to get platform name.');
  return platformName;
}
