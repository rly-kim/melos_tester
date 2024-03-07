//
//  PhotoSender+SaveToLocal.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation
import Photos

// fetch assets - save to local - return saved path

// asset 저장, 경로 계산 메서드
extension PhotoSender {
    internal func cacheAsset(asset: PHAsset, resource: PHAssetResource) async throws -> String {
        let path = try makeAssetPath(asset: asset, originalFilename: resource.originalFilename)
        try await writeFileIfNotExistsAtDirectory(path: path, resource: resource)
        return path
    }
    
    internal func makeAssetPath(asset: PHAsset, originalFilename: String) throws -> String {
        let id = asset.localIdentifier.replacingOccurrences(of: "/", with: "_")
        let modifiedDate = String(asset.modificationDate?.timeIntervalSince1970 ?? 0)
        var homePath = NSTemporaryDirectory()
        homePath.append(id)
        homePath.append(modifiedDate)
        let filename = "\(id)_\(modifiedDate)_o_\(originalFilename)"
        
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
    
    // 경로에 파일이 존재하지 않는다면 저장하고, 존재한다면 저장하지 않는다.
    internal func writeFileIfNotExistsAtDirectory(path: String, resource: PHAssetResource) async throws {
        switch FileManager.default.fileExists(atPath: path) {
        case true:
            // 이미 경로에 사진이 저장되어 있다면 추가로 저장할 필요 없음
            debugPrint("can be read cache from \(path)")
        case false:
            try await writeAssetAtDirectory(path: path, resource: resource)
        }
    }
    
    internal func writeAssetAtDirectory(path: String, resource: PHAssetResource) async throws {
        let options = PHAssetResourceRequestOptions()
        options.isNetworkAccessAllowed = true
        let resourceManager = PHAssetResourceManager.default()
        let fileUrl = URL(fileURLWithPath: path)
        do {
            try await resourceManager.writeData(for: resource,
                                            toFile: fileUrl,
                                            options: options)
        } catch {
            throw PhotoRetrieverError.saveFailed
        }
    }
}
