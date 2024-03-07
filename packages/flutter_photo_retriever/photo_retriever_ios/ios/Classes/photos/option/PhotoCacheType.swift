//
//  PhotoCacheType.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation

enum PhotoCacheType {
    case memory, local
    
    static func fromValue(value: Int) -> PhotoCacheType? {
        switch value {
        case 0:
            return PhotoCacheType.memory
        case 1:
            return PhotoCacheType.local
        default:
            return nil
        }
    }
    func toValue() -> Int {
        switch self {
        case PhotoCacheType.memory:
            return 0
        case PhotoCacheType.local:
            return 1
        }
    }
}
