import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'shake_gesture_test_helper_method_channel.dart';

abstract class ShakeGestureTestHelperPlatform extends PlatformInterface {
  /// Constructs a ShakeGestureTestHelperPlatform.
  ShakeGestureTestHelperPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShakeGestureTestHelperPlatform _instance =
      MethodChannelShakeGestureTestHelper();

  /// The default instance of [ShakeGestureTestHelperPlatform] to use.
  ///
  /// Defaults to [MethodChannelShakeGestureTestHelper].
  static ShakeGestureTestHelperPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShakeGestureTestHelperPlatform] when
  /// they register themselves.
  static set instance(ShakeGestureTestHelperPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> shake() async {
    throw UnimplementedError('shake() has not been implemented.');
  }
}
