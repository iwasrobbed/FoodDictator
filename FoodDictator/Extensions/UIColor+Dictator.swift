//
//  UIColor+Dictator.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Food Dictator Color Scheme

    public class func dictatorWhite() -> UIColor           { return whiteColor() }
    public class func dictatorBlack() -> UIColor           { return color(0x36373C) }
    public class func dictatorPink() -> UIColor            { return color(0xE95D8C) }
    public class func dictatorBlue() -> UIColor            { return color(0x56C7FF) }
    public class func dictatorCellSelection() -> UIColor   { return color(0xF1F1F1)}
    public class func dictatorGrayText() -> UIColor        { return color(0x9B9B9B) }

    public class func dictatorTextField() -> UIColor        { return color(0xFAFAFA) }
    public class func dictatorTextFieldBorder() -> UIColor  { return color(0xE3E3E3) }

}

// MARK: - Private Methods

private extension UIColor {

    /**
     Returns a `UIColor` object for the given hexadecimal and alpha values

     - parameter hex6:  A hexadecimal color value
     - parameter alpha: Opacity

     - returns: A `UIColor` object
     */
    class func color(hex6: UInt32, _ alpha: CGFloat = 1) -> UIColor {
        let divisor = CGFloat(255)
        let red = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let green = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let blue = CGFloat(hex6 & 0x0000FF) / divisor
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}