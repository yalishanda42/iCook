//
//  UIColor+AssetColors.swift
//  iCook
//
//  Created by Alexander Ignatov on 21.03.20.
//  Copyright © 2020 Alexander Ignatov. All rights reserved.
//

import UIKit

extension UIColor {
    static let accentDarker = UIColor.fromColorAsset("accent-darker")
    static let accentLighter = UIColor.fromColorAsset("accent-lighter")
    static let backgroundDarker = UIColor.fromColorAsset("background-darker")
    static let backgroundLighter = UIColor.fromColorAsset("background-lighter")
    static let deepPurple = UIColor.fromColorAsset("deep-purple")
    static let mediumGray = UIColor.fromColorAsset("mediumgrey")
}

extension UIColor {
    static func fromColorAsset(_ name: String) -> UIColor {
        guard let result = UIColor(named: name) else {
             fatalError("No UIColor named \(name) exists!")
        }
        return result
    }
}
