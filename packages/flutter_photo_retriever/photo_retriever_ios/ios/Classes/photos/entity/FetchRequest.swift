//
//  FetchRequest.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation

struct FetchRequest {
    let thumbnailOption: ThumbLoadOption
    static func fromJson(json: [String: Any]) -> FetchRequest? {
        guard let option = ThumbLoadOption.fromJson(json: json["option"] as! [String : Any]) else {
            return nil
        }
        return FetchRequest(
            thumbnailOption: option
        )
    }
}

struct FetchOriginalPhotoRequest {
    let identifier: String
    static func fromJson(json: [String: Any]) -> FetchOriginalPhotoRequest? {
        return FetchOriginalPhotoRequest(
            identifier: json["identifier"] as! String
        )
    }
}
