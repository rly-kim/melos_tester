//
//  PhotoEntity.swift
//  photo_permission
//
//  Created by kimrlyunah on 2/15/24.
//

import Foundation
import Flutter

protocol PhotoEntity {
    func toJson() -> Dictionary<String, Any>
}

struct RawPhotoEntity : PhotoEntity {
    let localIdentifier: String
    var byteImage: Data?
    
    init(localIdentifier: String, byteImage: Data?) {
        self.localIdentifier = localIdentifier
        self.byteImage = byteImage
    }
    
    func toJson() -> Dictionary<String, Any> {
        return [
            "localIdentifier": localIdentifier,
            "byteImage": FlutterStandardTypedData(bytes: self.byteImage ?? Data()),
        ]
    }
}

struct PathPhotoEntity : PhotoEntity {
    let localIdentifier: String
    var localPath: String?
    
    init(localIdentifier: String, localPath: String?) {
        self.localIdentifier = localIdentifier
        self.localPath = localPath
    }
    
    func toJson() -> Dictionary<String, Any> {
        return [
            "localIdentifier": localIdentifier,
            "localPath": localPath ?? "",
        ]
    }
}
