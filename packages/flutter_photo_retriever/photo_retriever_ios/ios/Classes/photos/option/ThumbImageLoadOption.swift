//
//  ThumbImageLoadOption.swift
//  Runner
//
//  Created by kimrlyunah on 2/20/24.
//

import Foundation

enum ThumbImageLoadOption {
    case png
    case jpeg
    
    static func fromValue(value: Int) -> ThumbImageLoadOption? {
        switch value {
        case 0:
            return ThumbImageLoadOption.png
        case 1:
            return ThumbImageLoadOption.jpeg
        default:
            return nil
        }
    }
}
