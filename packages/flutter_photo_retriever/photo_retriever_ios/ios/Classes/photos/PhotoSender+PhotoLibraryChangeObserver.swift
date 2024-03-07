//
//  PhotoSender+PhotoLibraryChangeObserver.swift
//  Runner
//
//  Created by kimrlyunah on 2/19/24.
//

import Foundation
import Photos

extension PhotoSender : PHPhotoLibraryChangeObserver {

    func close() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    func registerObserver() {
        // 변경사항 감지를 위해 등록
        PHPhotoLibrary.shared().register(self)
        debugPrint("옵저버 등록: \(String(describing: fetchedPhotos))")
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let photos = fetchedPhotos else {
            return
        }
        
        let details = changeInstance.changeDetails(for: photos)
        
        Task {
            if oldThumbnailOption != nil {
                let thumbnails = try await fetchThumbnails(thumbnailOption: oldThumbnailOption!)
                DispatchQueue.main.async {
                    self.channel.invokeMethod("update", arguments: self.convertThumbnailsToJson(entities: thumbnails))
                }
            }
        }

        Task {
            DispatchQueue.main.async {
                self.channel.invokeMethod("galleryObserved",
                                          arguments: self.convertObservedToJson(changed:details?.insertedObjects, removed: details?.removedObjects, inserted:details?.insertedObjects))
            }
        }
        
        // oldPhotos 업데이트
        fetchedPhotos = PHAsset.fetchAssets(with: nil)
    }
    
}
