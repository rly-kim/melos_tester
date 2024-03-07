import UIKit

public class ScreenDefender {
    
    private var window: UIWindow? = nil
    private var screenImage: UIImageView? = nil
    private var capturePreventImage: UIImageView = {
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        imageView.image = UIImage(named: "AppIcon")
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit;
        imageView.clipsToBounds = true;
        return imageView
    }()
    private var screenBlur: UIView? = nil
    private var screenColor: UIView? = nil
    private var screenPrevent = UITextField()
    private var screenshotObserve: NSObjectProtocol? = nil
    private var screenRecordObserve: NSObjectProtocol? = nil
    
    public init(window: UIWindow?) {
        self.window = window
    }
    
    // window에 미리 캡처 방지 스크린을 깔아둔다. 디폴트는 비활성화 상태이다.
    public func configurePreventionScreenshot() {
        guard let w = window else { return }
        if (!w.subviews.contains(screenPrevent)) {
            
            w.addSubview(screenPrevent)
            
            screenPrevent.centerYAnchor.constraint(equalTo: w.centerYAnchor).isActive = true
            screenPrevent.centerXAnchor.constraint(equalTo: w.centerXAnchor).isActive = true
            
            // 순서대로 레이어가 쌓이기 때문에! 가장 위로 올라갈 레이어를 마지막에 꼬옥~호출할 것
            // Window 레이어의 superlayer로 "내가 올리고 싶은 뷰"와 "캡처방지 뷰"를 순서대로 올린다.
            w.layer.superlayer?.addSublayer(capturePreventImage.layer)
            w.layer.superlayer?.addSublayer(screenPrevent.layer)
            
            if #available(iOS 17.0, *) {
                screenPrevent.layer.sublayers?.last?.addSublayer(w.layer)
            } else {
                screenPrevent.layer.sublayers?.first?.addSublayer(w.layer)
            }
        }
    }
    
    // 캡쳐 방지 이미지를 설정한다.
    public func setCaptureImage(image: String) {
        capturePreventImage.image = UIImage(named: image)
        enabledPreventScreenshot()
    }
    
    // 캡쳐 방지 스크린을 활성화 한다.
    internal func enabledPreventScreenshot() {
        screenPrevent.isSecureTextEntry = true
    }
    
    // 캡쳐 방지 스크린을 비활성화 한다.
    public func disablePreventScreenshot() {
        screenPrevent.isSecureTextEntry = false
    }
    
    public func enabledBlurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.light) {
        screenBlur = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        screenBlur?.addSubview(blurBackground)
        blurBackground.frame = (screenBlur?.frame)!
        window?.addSubview(screenBlur!)
    }
    
    public func disableBlurScreen() {
        screenBlur?.removeFromSuperview()
        screenBlur = nil
    }

    public func enabledColorScreen(hexColor: String) {
        guard let w = window else { return }
        screenColor = UIView(frame: w.bounds)
        guard let view = screenColor else { return }
        debugPrint("plugin color: \(hexColor)")
        view.backgroundColor = UIColor(hexString: hexColor)
        w.addSubview(view)
    }
    
    public func disableColorScreen() {
        screenColor?.removeFromSuperview()
        screenColor = nil
    }
    
    public func enabledImageScreen(named: String) {
        screenImage = UIImageView(frame: UIScreen.main.bounds)
        screenImage?.image = UIImage(named: named)
        screenImage?.isUserInteractionEnabled = false
        screenImage?.contentMode = .scaleAspectFill;
        screenImage?.clipsToBounds = true;
        window?.addSubview(screenImage!)
    }
    
    public func disableImageScreen() {
        screenImage?.removeFromSuperview()
        screenImage = nil
    }
    
    
    public func removeObserver(observer: NSObjectProtocol?) {
        guard let obs = observer else {return}
        NotificationCenter.default.removeObserver(obs)
    }
    
    // 캡쳐 감지 콜백을 감지하면 리스너에게 보내주는 옵저버를 제거한다.
    public func removeScreenshotObserver() {
        if screenshotObserve != nil {
            self.removeObserver(observer: screenshotObserve)
            self.screenshotObserve = nil
        }
    }
    
    // 녹화 옵저버가 있다면 제거한다.
    public func removeScreenRecordObserver() {
        if screenRecordObserve != nil {
            self.removeObserver(observer: screenRecordObserve)
            self.screenRecordObserve = nil
        }
    }
    
    // 캡쳐 옵저버, 녹화 옵저버를 제거한다.
    public func removeAllObserver() {
        self.removeScreenshotObserver()
        self.removeScreenRecordObserver()
    }
    
    // 캡쳐 옵저버를 등록한다.
    public func screenshotObserver(using onScreenshot: @escaping () -> Void) {
        screenshotObserve = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            onScreenshot()
        }
    }
    
    // 녹화 옵저버를 등록한다.
    @available(iOS 11.0, *)
    public func screenRecordObserver(using onScreenRecord: @escaping (Bool) -> Void) {
        screenRecordObserve =
        NotificationCenter.default.addObserver(
            forName: UIScreen.capturedDidChangeNotification,
            object: nil,
            queue: OperationQueue.main
        ) { notification in
            let isCaptured = UIScreen.main.isCaptured
            onScreenRecord(isCaptured)
        }
    }
    
    @available(iOS 11.0, *)
    public func screenIsRecording() -> Bool {
        return UIScreen.main.isCaptured
    }
}
