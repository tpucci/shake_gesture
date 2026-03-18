import Flutter
import UIKit

public class ShakeGesturePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "shake_gesture", binaryMessenger: registrar.messenger())
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
        guard let eventWindow = notification.userInfo?["window"] as? UIWindow else { return }
        let appWindows: [UIWindow]
        if #available(iOS 13.0, *) {
            appWindows = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
        } else {
            appWindows = UIApplication.shared.windows
        }
        if appWindows.contains(where: { $0 === eventWindow }) {
            DispatchQueue.main.async {
                self.channel.invokeMethod("onShake", arguments: nil)
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
