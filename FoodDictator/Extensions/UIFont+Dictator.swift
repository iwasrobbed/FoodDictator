//
//  UIFont+Dictator.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

// MARK: - Public API

extension UIFont {

    // MARK: - Dictator Font Scheme

    public class func dictatorNavigationTitle() -> UIFont   { return dictatorBold(20) }
    public class func dictatorFTUEText() -> UIFont          { return dictatorMedium(20) }

    // MARK: - UI Controls
    
    public class func dictatorTextField() -> UIFont         { return dictatorMedium(20) }
    public class func dictatorRoundedButton() -> UIFont     { return dictatorBold(24) }

    // MARK: - Dictator Generic Fonts

    public class func dictatorRegular(size: Float = 16) -> UIFont   { return dictatorFont(.Regular, size: size) }
    public class func dictatorMedium(size: Float = 16) -> UIFont    { return dictatorFont(.Medium, size: size) }
    public class func dictatorBold(size: Float = 16) -> UIFont      { return dictatorFont(.Bold, size: size) }
}

// MARK: - Private API

private extension UIFont {

    /**
     Dictator font styles
     */
    enum dictatorFontStyle: Int {
        case Regular, Medium, Bold

        func toFont(size: Float) -> UIFont {
            var fontName = ""
            switch self {
            case .Regular:
                fontName = "Texta-Regular"
            case .Medium:
                fontName = "Texta-Medium"
            case .Bold:
                fontName = "Texta-Bold"
            }
            return UIFont(name: fontName, size: CGFloat(size))!
        }
    }

    class func dictatorFont(style: dictatorFontStyle, size: Float) -> UIFont {
        let scaledSize = ceilf(size * scaleFactor())
        return style.toFont(scaledSize)
    }

    // TODO Proper font scaling
    class func scaleFactor() -> Float {
        return UIScreen.mainScreen().scale > 2.9 ? 1.0 : 0.8
    }
    
}