//
//  File.swift
//
//
//  Created by Loongman on 6/3/23.
//

import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle {
        let path = Bundle(for: ElegantEmojiPicker.self).path(forResource: "ElegantEmojiPicker", ofType: "bundle") ?? ""
        return Bundle(path: path) ?? Bundle.main
    }
}
#endif
