//
//  PhotoSender+Convert.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation
import UIKit
import Photos

extension PhotoSender {
    // convert thumbnail -> json
    internal func convertThumbnailsToJson(entities: [PhotoEntity]) -> Dictionary<String, Any> {
        return [
            "entities": entities.map { $0.toJson() },
            "type": fetchType.toValue()
        ]
    }
    internal func convertOriginalResultToJson(photo: Dictionary<String, Any>) -> Dictionary<String, Any> {
        return [
            "item": photo,
            "type": fetchType.toValue()
        ]
    }
    internal func convertToData(_ image: UIImage?, formatType type: ThumbImageLoadOption, quality: Float) -> Data? {
        var resultData: Data?
        guard let image = image else {
            return nil
        }
        if type == .png {
            resultData = image.pngData()
        } else {
            resultData = image.jpegData(compressionQuality: CGFloat(quality))
        }
        return resultData
    }
    internal func convertObservedToJson(changed: [PHObject]?, removed: [PHObject]?, inserted: [PHObject]?) -> Dictionary<String, Any> {
        var insertedResults: [String] = []
        var removedResults: [String] = []
        var changedResults: [String] = []
        if let insertedAssets = inserted {
            insertedResults = insertedAssets.map { e in
                e.localIdentifier
            }.compactMap { $0 }
        }
        if let removedAssets = removed {
            removedResults = removedAssets.map { e in
                e.localIdentifier
            }.compactMap { $0 }
        }
        if let changedAssets = removed {
            changedResults = changedAssets.map { e in
                e.localIdentifier
            }.compactMap { $0 }
        }
        return [
            "changed": changedResults,
            "removed": removedResults,
            "inserted": insertedResults,
        ]
    }
}
