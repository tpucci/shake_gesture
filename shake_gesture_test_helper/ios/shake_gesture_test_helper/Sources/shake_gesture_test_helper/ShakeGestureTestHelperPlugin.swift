import Flutter
import UIKit

public class ShakeGestureTestHelperPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "shake_gesture_test_helper", binaryMessenger: registrar.messenger())
    let instance = ShakeGestureTestHelperPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "shake":
      shake()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
    
    func shake() {
        let appWindows: [UIWindow]
        if #available(iOS 13.0, *) {
            appWindows = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        } else {
            appWindows = UIApplication.shared.windows
        }
        let window = appWindows.first ?? UIWindow()
        NotificationCenter.default.post(name: Notification.Name("ShakeMotionEventNotification"), object: nil, userInfo: ["window": window])
    }
}

class ShakeMotionEvent: UIEvent {
    override var type: UIEvent.EventType { return .motion }
    override var subtype: UIEvent.EventSubtype { return .motionShake }
}
