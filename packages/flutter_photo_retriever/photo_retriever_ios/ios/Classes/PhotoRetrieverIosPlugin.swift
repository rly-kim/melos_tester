import Flutter
import UIKit

public class PhotoRetrieverIosPlugin: NSObject, FlutterPlugin {
    
    var photoSender: PhotoSender? = nil
    var isRegistered: Bool = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter.startkit/photo_retriever", binaryMessenger: registrar.messenger())
        let instance = PhotoRetrieverIosPlugin()
        instance.photoSender = PhotoSender(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setCacheType":
            guard let photoSender = photoSender else {
                result(PhotoRetrieverError.notInitialized.flutterError)
                return
            }
            guard let argument = (call.arguments as! [String: Any])["type"] else {
                result(false)
                return
            }
            guard let type = PhotoCacheType.fromValue(value: argument as! Int) else {
                result(false)
                return
            }
            photoSender.setType(type: type)
            result(true)
        case "fetchThumbnails":
            Task { [result] in
                guard let photoSender = photoSender else {
                    result(PhotoRetrieverError.notInitialized.flutterError)
                    return
                }
                guard let arguments = FetchRequest.fromJson(json: call.arguments as! [String: Any]) else {
                    result(nil)
                    return
                }
                do {
                    let photos = try await photoSender.requestThumbnails(thumbnailOption: arguments.thumbnailOption)
                    if !self.isRegistered {
                        self.isRegistered = true
                        photoSender.registerObserver()
                    }
                    let resultJson = photoSender.convertThumbnailsToJson(entities: photos)
                    result(resultJson)
                } catch {
                    result(error.flutterError)
                }
            }
        case "fetchOriginalPhoto":
            Task  {[result] in
                guard let photoSender = photoSender else {
                    result(PhotoRetrieverError.notInitialized.flutterError)
                    return
                }
                guard let arguments = FetchOriginalPhotoRequest.fromJson(json: call.arguments as! [String: Any]) else {
                    result(nil)
                    return
                }
                do {
                    guard let originalPhoto = try await photoSender.requestOriginalPhoto(id: arguments.identifier) else {
                        result(nil)
                        return
                    }
                    let resultJson = photoSender.convertOriginalResultToJson(photo: originalPhoto.toJson())
                    result(resultJson)
                } catch {
                    result(error.flutterError)
                }
            }
        default:
            result(PhotoRetrieverError.unknownMethodName.flutterError)
        }
    }
}

internal enum PhotoRetrieverError: Error {
    case unknownMethodName // 메서드 이름이 존재하지 않음
    case unknownAsset // identifier로 찾기 실패, requestImage 실패
    case saveFailed // 저장 실패
    case notInitialized
    // 위의 경우를 제외, 결과를 Nil로 받는 경우는 앱에서 디폴트 익셉션으로 처리
}

internal extension Error {
    var flutterError: FlutterError {
        switch self as? PhotoRetrieverError {
        case .unknownMethodName:
            return FlutterError(code: "unknownMethodName", message: nil, details: nil)
        case .unknownAsset:
            return FlutterError(code: "unknownAsset", message: nil, details: nil)
        case .saveFailed:
            return FlutterError(code: "saveFailed", message: nil, details: nil)
        case .notInitialized:
            return FlutterError(code: "notInitialized", message: nil, details: nil)
        case .none:
            return FlutterError(code: "error", message: nil, details: nil)
        }
    }
}
