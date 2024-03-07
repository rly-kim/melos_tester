//
//  ThumbLoadOption.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation
import Photos

struct ThumbLoadOption {
    let deliveryMode: PHImageRequestOptionsDeliveryMode
    let resizeMode: PHImageRequestOptionsResizeMode
    let contentMode: PHImageContentMode
    let width: Double
    let height: Double
    let quality: Float
    let format: ThumbImageLoadOption
    
    init(deliveryMode: PHImageRequestOptionsDeliveryMode = .opportunistic,
         resizeMode: PHImageRequestOptionsResizeMode = .fast,
         contentMode: PHImageContentMode = .aspectFit,
         width: Double,
         height: Double,
         quality: Float,
         format: ThumbImageLoadOption) {
        self.deliveryMode = deliveryMode
        self.resizeMode = resizeMode
        self.contentMode = contentMode
        self.width = width
        self.height = height
        self.quality = quality
        self.format = format
    }
    
    static func fromJson(json: [String: Any]) -> ThumbLoadOption? {
        guard let deliveryMode = PHImageRequestOptionsDeliveryMode.fromValue(value: json["deliveryMode"] as! Int) else {
            return nil
        }
        guard let resizeMode = PHImageRequestOptionsResizeMode.fromValue(value: json["resizeMode"] as! Int) else {
            return nil
        }
        guard let contentMode = PHImageContentMode.fromValue(value: json["contentMode"] as! Int) else {
            return nil
        }
        guard let format = ThumbImageLoadOption.fromValue(value: json["format"] as! Int) else {
            return nil
        }
        return ThumbLoadOption(
            deliveryMode: deliveryMode,
            resizeMode: resizeMode,
            contentMode: contentMode,
            width: json["width"] as! Double,
            height: json["height"] as! Double,
            quality: json["quality"] as! Float,
            format: format
        )
    }
}

extension PHImageRequestOptionsDeliveryMode {
    static func fromValue(value: Int) -> PHImageRequestOptionsDeliveryMode? {
        switch value {
        case 0:
            return PHImageRequestOptionsDeliveryMode.opportunistic
        case 1:
            return PHImageRequestOptionsDeliveryMode.highQualityFormat
        case 2:
            return PHImageRequestOptionsDeliveryMode.fastFormat
        default:
            return nil
        }
    }
}

extension PHImageRequestOptionsResizeMode {
    static func fromValue(value: Int) -> PHImageRequestOptionsResizeMode? {
        switch value {
        case 0:
            return PHImageRequestOptionsResizeMode.none
        case 1:
            return PHImageRequestOptionsResizeMode.fast
        case 2:
            return PHImageRequestOptionsResizeMode.exact
        default:
            return nil
        }
    }
}
extension PHImageContentMode {
    static func fromValue(value: Int) -> PHImageContentMode? {
        switch value {
        case 0:
            return PHImageContentMode.aspectFit
        case 1:
            return PHImageContentMode.aspectFill
        default:
            return nil
        }
    }
}
