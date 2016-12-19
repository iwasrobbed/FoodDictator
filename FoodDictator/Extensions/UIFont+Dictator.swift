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

    public class func dictatorRegular(_ size: Float = 16) -> UIFont   { return dictatorFont(.regular, size: size) }
    public class func dictatorMedium(_ size: Float = 16) -> UIFont    { return dictatorFont(.medium, size: size) }
    public class func dictatorBold(_ size: Float = 16) -> UIFont      { return dictatorFont(.bold, size: size) }
}

// MARK: - Private API

private extension UIFont {

    /**
     Dictator font styles
     */
    enum dictatorFontStyle: Int {
        case regular, medium, bold

        func toFont(_ size: Float) -> UIFont {
            var fontName = ""
            switch self {
            case .regular:
                fontName = "Texta-Regular"
            case .medium:
                fontName = "Texta-Medium"
            case .bold:
                fontName = "Texta-Bold"
            }
            return UIFont(name: fontName, size: CGFloat(size))!
        }
    }

    class func dictatorFont(_ style: dictatorFontStyle, size: Float) -> UIFont {
        let scaledSize = ceilf(size * scaleFactor())
        return style.toFont(scaledSize)
    }

    // TODO Proper font scaling
    class func scaleFactor() -> Float {
        return UIScreen.main.scale > 2.9 ? 1.0 : 0.8
    }
    
}
