import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shake_gesture_platform_interface/src/method_channel_shake_gesture.dart';

/// The interface that implementations of shake_gesture must implement.
///
/// Platform implementations should extend this class
/// rather than implement it as `ShakeGesture`.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that `implements`
/// this interface will be broken by newly added [ShakeGesturePlatform] methods.
abstract class ShakeGesturePlatform extends PlatformInterface {
  /// Constructs a ShakeGesturePlatform.
  ShakeGesturePlatform() : super(token: _token);

  static final Object _token = Object();

  static ShakeGesturePlatform _instance = MethodChannelShakeGesture();

  /// The default instance of [ShakeGesturePlatform] to use.
  ///
  /// Defaults to [MethodChannelShakeGesture].
  static ShakeGesturePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [ShakeGesturePlatform] when they register themselves.
  static set instance(ShakeGesturePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  final _callbackRegistry = <VoidCallback>{};

  /// Registers a callback that will be called when a shake gesture is detected.
  void registerCallback({required VoidCallback onShake}) {
    _callbackRegistry.add(onShake);
  }

  /// Unregisters a callback that will be called when
  /// a shake gesture is detected.
  void unregisterCallback({required VoidCallback onShake}) {
    _callbackRegistry.remove(onShake);
  }

  /// Called when a shake gesture is detected.
  void onShake() {
    for (final callback in _callbackRegistry) {
      callback();
    }
  }
}
