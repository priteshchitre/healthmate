//
//  Font.swift
//  AstroCompatibility
//
//  Created by AppDeveloper on 7/10/20.
//  Copyright © 2020 AppDeveloper. All rights reserved.
//

import UIKit

struct Font {
    
    static let RobotoThinItalic = "Roboto-ThinItalic"
    static let RobotoRegular = "Roboto-Regular"
    static let RobotoMedium = "Roboto-Medium"
    static let RobotoMediumItalic = "Roboto-MediumItalic"
    static let RobotoLightItalic = "Roboto-LightItalic"
    static let RobotoLight = "Roboto-Light"
    static let RobotoItalic = "Roboto-Italic"
    static let RobotoBoldItalic = "Roboto-BoldItalic"
    static let RobotoBold = "Roboto-Bold"
    static let RobotoBlackItalic = "Roboto-BlackItalic"
    static let RobotoBlack = "Roboto-Black"
}
extension UIFont {
    private static func setCustomFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
//        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }

    static func customFont(name: String, size: CGFloat) -> UIFont {
        return setCustomFont(name: name, size: size)
    }
}
