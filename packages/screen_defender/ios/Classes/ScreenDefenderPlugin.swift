import Flutter
import UIKit

public class ScreenDefenderPlugin: NSObject, FlutterPlugin {
    
    private var screenDefender: ScreenDefender? = nil
    private static var channel: FlutterMethodChannel? = nil
    
    private var enabledPreventScreenshot: EnabledStatus = .idle
    private var enabledProtectDataLeakageWithBlur: EnabledStatus = .idle
    private var enabledProtectDataLeakageWithImage: EnabledStatus = .idle
    private var enabledProtectDataLeakageWithColor: EnabledStatus = .idle
    private var protectDataLeakageWithImageName: String = ""
    private var protectDataLeakageWithColor: String = ""
    
    init(screenDefender: ScreenDefender) {
        self.screenDefender = screenDefender
        debugPrint("code in plugin")
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "screen_defender", binaryMessenger: registrar.messenger())
        
        let window = UIApplication.shared.delegate?.window
        let screenDefender = ScreenDefender(window: window as? UIWindow)
        screenDefender.configurePreventionScreenshot()
        
        let instance = ScreenDefenderPlugin(screenDefender: screenDefender)
        registrar.addMethodCallDelegate(instance, channel: channel!)
        registrar.addApplicationDelegate(instance)
    }
    
    // active -> in-active
    public func applicationWillResignActive(_ application: UIApplication) {
        // Protect Data Leakage - ON
        if enabledProtectDataLeakageWithColor == .on {
            screenDefender?.enabledColorScreen(hexColor: protectDataLeakageWithColor)
        }
        if enabledProtectDataLeakageWithImage == .on {
            screenDefender?.enabledImageScreen(named: protectDataLeakageWithImageName)
        }
        if enabledProtectDataLeakageWithBlur == .on {
            screenDefender?.enabledBlurScreen()
        }

        // 캡처 방지 화면 활성화 시 상태가 on 또는 off이다.
        // app active 상태일 때만 캡처 방지 화면을 켜기 위해 아래의 작업을 수행한다.
        if enabledPreventScreenshot == .on {
            screenDefender?.disablePreventScreenshot()
            enabledPreventScreenshot = .off
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Protect Data Leakage - OFF
        
        if enabledProtectDataLeakageWithColor == .on {
            screenDefender?.disableColorScreen()
        }
        if enabledProtectDataLeakageWithImage == .on {
            screenDefender?.disableImageScreen()
        }
        if enabledProtectDataLeakageWithBlur == .on {
            screenDefender?.disableBlurScreen()
        }
        
        // 캡처 방지 화면 활성화 시 상태가 on 또는 off이다.
        // app active 상태일 때만 캡처 방지 화면을 켜기 위해 아래의 작업을 수행한다.
        if enabledPreventScreenshot == .off {
            screenDefender?.enabledPreventScreenshot()
            enabledPreventScreenshot = .on
        }
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? Dictionary<String, String>
        
        switch call.method {
        case "disableSecureTaskView":
            enabledProtectDataLeakageWithColor = .off
            enabledProtectDataLeakageWithImage = .off
            enabledProtectDataLeakageWithBlur = .off
            screenDefender?.disableColorScreen()
            screenDefender?.disableImageScreen()
            screenDefender?.disableBlurScreen()
            result(true)
            break
        case "protectDataLeakageWithImage":
            if args != nil {
                protectDataLeakageWithImageName = args!["image"] ?? "LaunchImage"
            }
            enabledProtectDataLeakageWithImage = .on
            result(true)
            break
        case "protectDataLeakageWithImageOff":
            enabledProtectDataLeakageWithImage = .off
            screenDefender?.disableImageScreen()
            result(true)
            break
        case "protectDataLeakageWithColor":
            if args != nil {
                guard let hexColor = args!["hexColor"] else {return}
                protectDataLeakageWithColor = hexColor
                enabledProtectDataLeakageWithColor = .on
            }
            result(true)
            break
        case "protectDataLeakageWithColorOff":
            enabledProtectDataLeakageWithColor = .off
            screenDefender?.disableColorScreen()
            result(true)
            break
        case "protectDataLeakageWithBlur":
            enabledProtectDataLeakageWithBlur = .on
            result(true)
            break
        case "protectDataLeakageWithBlurOff":
            enabledProtectDataLeakageWithBlur = .off
            screenDefender?.disableBlurScreen()
            result(true)
            break
        case "capturePreventImageOn":
            guard let image = args!["image"] else {
                result(false)
                break
            }
            enabledPreventScreenshot = .on
            screenDefender?.setCaptureImage(image: image)
            result(true)
            break
        case "disableCapturePreventImage":
            enabledPreventScreenshot = .idle // 활비활성화 상태로 전환
            screenDefender?.disablePreventScreenshot()
            result(true)
            break
        case "isRecording":
            result(screenDefender?.screenIsRecording() ?? false)
            return
        case "addListener":
            screenDefender?.removeScreenshotObserver()
            screenDefender?.screenshotObserver {
                ScreenDefenderPlugin.channel?.invokeMethod("onScreenshot", arguments: nil)
            }
            
            if #available(iOS 11.0, *) {
                screenDefender?.removeScreenRecordObserver()
                screenDefender?.screenRecordObserver { isCaptured in
                    ScreenDefenderPlugin.channel?.invokeMethod("onScreenRecord", arguments: isCaptured)
                }
            }
            
            result("listened")
            break
        case "removeListener":
            screenDefender?.removeAllObserver()
            
            result("removed")
            break
        default:
            result(false)
            break
        }
    }
    
    deinit {
        screenDefender?.removeAllObserver()
    }
}
