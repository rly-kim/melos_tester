//
//  PhotoSender.swift
//  photo_permission
//
//  Created by kimrlyunah on 2/15/24.
//

import Foundation
import Photos
import UIKit
import Flutter

class PhotoSender: NSObject {
    
    let IMAGE_CACHE_PATH = ".image"
    let requiredAccessLevel: PHAccessLevel = .readWrite
    var fetchedPhotos : PHFetchResult<PHAsset>? = nil
    var fetchType: PhotoCacheType = PhotoCacheType.memory
    var oldThumbnailOption: ThumbLoadOption? = nil
    
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    deinit {
        self.close()
    }
    
    func setType(type: PhotoCacheType) {
        fetchType = type
    }
    
    func requestThumbnails(thumbnailOption: ThumbLoadOption) async throws -> [PhotoEntity] {
        if checkPhotoPermission() {
            return try await fetchThumbnails(thumbnailOption: thumbnailOption)
        } else {
            if await requestPhotoAuthorization() {
                return try await fetchThumbnails(thumbnailOption: thumbnailOption)
            }
        }
        return []
    }
    
    func requestOriginalPhoto(id: String) async throws -> PhotoEntity? {
        if checkPhotoPermission() {
            switch self.fetchType {
            case.memory:
                let byteArray = try await fetchOriginalPhotoAsUInt8(identifier: id)
                return RawPhotoEntity(localIdentifier: id, byteImage: byteArray)
            case .local:
                let path = try await fetchOriginalPhotoAsPath(identifier: id)
                return PathPhotoEntity(localIdentifier: id, localPath: path)
            }
        } else {
            return nil
        }
    }
    
    // 권한 요청
    internal func requestPhotoAuthorization() async -> Bool {
        return await withCheckedContinuation { continuation in
            PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
                switch authorizationStatus {
                case .limited, .authorized:
                    continuation.resume(returning: true)
                default:
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    // 권한 체크
    private func checkPhotoPermission() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: requiredAccessLevel)
        switch status {
        case .limited, .authorized:
            return true
        default:
            return false
        }
    }
    
    internal func fetchThumbnails(thumbnailOption: ThumbLoadOption) async throws -> [PhotoEntity] {
        var photoAssets: [PHAsset] = []
        var results: [PhotoEntity] = []
        let fetchedResult = fetchAssets()
        fetchedPhotos = fetchedResult // for observer
        oldThumbnailOption = thumbnailOption
        fetchedResult.enumerateObjects { asset, _, _ in
            photoAssets.append(asset)
        }
        for asset in photoAssets {
            let entity: PhotoEntity = try await withCheckedThrowingContinuation({ continuation in
                self.getThumb(asset: asset, option: thumbnailOption) { thumbnail in
                    if let thumbnail = thumbnail {
                        guard let resource = self.getAssetResource(asset: asset) else {
                            return
                        }
                        switch self.fetchType {
                        case .memory:
                            // 썸네일을 저장하지 않고 [UInt8]로 리턴
                            let entity = RawPhotoEntity(localIdentifier: asset.localIdentifier, byteImage: thumbnail)
                            continuation.resume(returning: entity)
                        case .local:
                            // 썸네일 (Data)를 로컬에 저장하고 경로를 리턴
                            do {
                                let localPath = try self.cacheThumb(thumbnail: thumbnail, filename: resource.originalFilename, identifier: asset.localIdentifier, modifiedDate: asset.modificationDate)
                                let entity = PathPhotoEntity(localIdentifier: asset.localIdentifier, localPath: localPath)
                                continuation.resume(returning: entity)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        }
                    } else {
                        continuation.resume(throwing: PhotoRetrieverError.unknownAsset)
                    }
                }
            })
            results.append(entity)
        }
        return results
    }
    
    private func fetchAssets() -> PHFetchResult<PHAsset> {
        var fetchResult = PHFetchResult<PHAsset>()
        
        fetchResult = PHAsset.fetchAssets(with: nil) // fetchOption(predicate, sort etc)이 따로 지정되지 않았다면 default 사용.
        
        return fetchResult
    }
    
    private func getThumb(asset: PHAsset, option: ThumbLoadOption, handler: @escaping (Data?) -> Void) {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        // requestOptions.isSynchronous = false면 선택한 deliveryMode를 사용
        // true면 deliveryMode는 항상 highQualityFormat
        // resultHandler가 반드시 한번만 불려야 하는 경우 isSynchronous를 true로 사용할 것
        requestOptions.isSynchronous = true
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = option.deliveryMode
        requestOptions.resizeMode = option.resizeMode
        
        let width = option.width
        let height = option.height
        manager.requestImage(for: asset,
                             targetSize: CGSize(width: width, height: height),
                             contentMode: option.contentMode,
                             options: requestOptions) { result, info in
            
            if let imageData = self.convertToData(result, formatType: option.format, quality: option.quality) {
                handler(imageData)
                return
            }
            handler(nil)
        }
    }
    
    internal func getAssetResource(asset: PHAsset) -> PHAssetResource? {
        let resources = PHAssetResource.assetResources(for: asset)
        if resources.isEmpty {
            return nil
        }
        
        if resources.count == 1 {
            return resources[0]
        }
        
        for res in resources {
            if asset.mediaType == .image && res.type == .photo || asset.mediaType == .image && res.type == .fullSizePhoto {
                return res
            }
        }
        return nil
    }
}
