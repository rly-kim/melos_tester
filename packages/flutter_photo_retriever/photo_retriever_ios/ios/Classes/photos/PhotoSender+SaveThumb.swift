//
//  PhotoSender+SaveThumb.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation
import Photos
import UIKit

// thumb 저장, 경로 계산 메서드
extension PhotoSender {
    internal func cacheThumb(thumbnail: Data, filename: String, identifier: String, modifiedDate: Date?) throws -> String {
        let path = try makeThumbPath(thumbnail: thumbnail, filename: filename, identifier: identifier, modifiedDate: modifiedDate)
        try writeThumbIfNotExistsAtDirectory(path: path, thumbnail: thumbnail)
        return path
    }
    
    internal func makeThumbPath(thumbnail: Data, filename: String, identifier: String, modifiedDate: Date?) throws -> String {
        // make cache file name
        let id = identifier.replacingOccurrences(of: "/", with: "_")
        let modifiedDate = String(modifiedDate?.timeIntervalSince1970 ?? 0)
        let filename = "\(id)_\(modifiedDate)_thumb_\(filename)"
        
        // make directory path
        var homePath = NSTemporaryDirectory()
        homePath.append(id)
        homePath.append(modifiedDate)
        let dirPath = homePath.appending(IMAGE_CACHE_PATH)
        
        let manager = FileManager.default
        do {
            try? manager.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw PhotoRetrieverError.saveFailed
        }
        let fullPath = "\(dirPath)/\(filename)"
        debugPrint("PHAsset path = \(fullPath)")
        return fullPath
    }
    
    internal func writeThumbIfNotExistsAtDirectory(path: String, thumbnail: Data) throws {
        switch FileManager.default.fileExists(atPath: path) {
        case true:
            debugPrint("read cache from \(path)")
        case false:
            try writeThumbAtDirectory(path: path, thumbnail: thumbnail)
        }
    }
    
    internal func writeThumbAtDirectory(path: String, thumbnail: Data) throws {
        let fileUrl = URL(fileURLWithPath: path)
        do {
            try? thumbnail.write(to: fileUrl)
        } catch {
            throw PhotoRetrieverError.saveFailed
        }
    }
}
