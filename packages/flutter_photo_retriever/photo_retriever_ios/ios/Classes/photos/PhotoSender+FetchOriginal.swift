//
//  PhotoSender+FetchOriginal.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation
import Photos

extension PhotoSender {
    internal func fetchOriginalPhotoAsUInt8(identifier: String) async throws -> Data? {
        // identifier로 asset을 찾아와서 오리지널 사이즈로 리턴
        let fetched = try self.fetchAssetWithIdentifier(withIdentifier: identifier)
        guard let option = oldThumbnailOption else {
            return nil
        }
        // 가져온 asset을 uint8로 변환하기 위해 UIImage로 변환 (as original size)
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = option.deliveryMode
        options.resizeMode = option.resizeMode
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true // 2번 이상 불림 방지
        let data = await withCheckedContinuation { continuation in
            manager.requestImage(for: fetched, targetSize: PHImageManagerMaximumSize, contentMode: option.contentMode, options: options) { image, _ in
                let data = self.convertToData(image, formatType: option.format, quality: 100)
                continuation.resume(returning: data)
            }
        }
        guard let data = data else {
            throw PhotoRetrieverError.unknownAsset
        }
        return data
    }
    
    private func fetchAssetWithIdentifier(withIdentifier identifier: String) throws -> PHAsset {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        guard let asset = fetchResult.firstObject else {
            throw PhotoRetrieverError.unknownAsset
        }
        return asset
    }
    
    internal func fetchOriginalPhotoAsPath(identifier: String) async throws -> String? {
        // identifier로 저장 경로를 찾아온 후,
        // 해당 경로에 캐시된 사진이 있는지 보고,
        // 캐시된 사진이 없으면 identifier로 asset을 찾아온 후 저장, 저장 경로 리턴
        let asset = try fetchAssetWithIdentifier(withIdentifier: identifier)
        guard let resource = getAssetResource(asset: asset) else {
            return nil
        }
        let path = try await cacheAsset(asset: asset, resource: resource)
        return path
    }
}
