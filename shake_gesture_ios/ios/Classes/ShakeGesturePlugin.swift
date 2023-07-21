import Flutter
import UIKit

public class ShakeGesturePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "shake_gesture_ios", binaryMessenger: registrar.messenger())
        let instance = ShakeGesturePlugin(methodChannel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private let channel: FlutterMethodChannel

    init(methodChannel: FlutterMethodChannel) {
        channel = methodChannel
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(handleEvent(_:)), name: .shakeMotionEventNotification, object: nil)

    }

    @objc func handleEvent(_ notification: Notification) {
        if let eventData = notification.userInfo?["window"] as? UIWindow {
            if let appDelegate = UIApplication.shared.delegate, let window = appDelegate.window {
                if (window == eventData) {
                    DispatchQueue.main.async {
                        self.channel.invokeMethod("shake_event", arguments: nil)
                    }
                }
            }
        }
    }
}

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (motion == .motionShake) {
            NotificationCenter.default.post(name: .shakeMotionEventNotification, object: nil, userInfo: ["window": self])
        }
    }
}

extension Notification.Name {
    static let shakeMotionEventNotification = Notification.Name("ShakeMotionEventNotification")
}
