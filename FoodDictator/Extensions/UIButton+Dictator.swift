//
//  UIButton+Dictator.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

// MARK: - Public API

extension UIButton {

    /**
     *  Configuration constants
     */
    struct dictatorConfig {
        static let buttonHeight = 50
        static let buttonWidthPercentage = 0.9
    }

    /**
     Dictator button styles
     */
    enum dictatorButtonStyle: Int {
        case Pink, Blue

        func toColor() -> UIColor {
            switch self {
            case .Pink:
                return UIColor.dictatorPink()
            case .Blue:
                return UIColor.dictatorBlue()
            }
        }
    }

    /**
     Creates a rounded button based on style presets

     - parameter style:  The color style of the button
     - parameter title:  The title text
     - parameter target: Class to target
     - parameter action: Function to call upon touch up inside

     - returns: A rounded button with the given style
     */
    class func dictatorRounded(style: dictatorButtonStyle, title: String, target: AnyObject, action: Selector) -> UIButton {
        let button = dictatorGenericButton(title, target: target, action: action)
        button.backgroundColor = style.toColor()
        button.dictatorRoundCorners()
        button.titleLabel?.font = UIFont.dictatorRoundedButton()
        return button
    }

    /**
     Creates a button for logging in with Facebook

     - parameter target: Class to target
     - parameter action: Function to call upon touch up inside

     - returns: A Facebook login button
     */
    class func dictatorFacebook(target: AnyObject, action: Selector) -> UIButton {
        let button = dictatorRounded(.Pink, title: FTUELocalizations.FACEBOOK, target: target, action: action)
        button.setImage(UIImage(named: "FBLogo"), forState: .Normal)
        button.adjustsImageWhenHighlighted = false
        button.imageEdgeInsets = UIEdgeInsetsMake(10, 30, 10, 80)
        return button
    }

    /**
     Creates an image-only button

     - parameter image:  Image to use for background
     - parameter target: Class to target
     - parameter action: Function to call upon touch up inside

     - returns: An image-based button
     */
    class func dictatorImageOnly(image: UIImage, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(image, forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return button
    }

    /**
     Creates a navigation back button

     - parameter target: Class to target
     - parameter action: Function to call upon touch up inside

     - returns: A navigation back button with the given color
     */
    class func dictatorBackButton(target: AnyObject, action: Selector) -> UIButton {
        return dictatorImageOnly(UIImage(named: "BackArrowBlack")!, target: target, action: action)
    }

    // Dim buttons on disable
    override public var enabled: Bool {
        didSet { alpha = enabled ? 1 : 0.5 }
    }
}

// MARK: - Private API

private extension UIButton {

    class func dictatorGenericButton(title: String, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.dictatorWhite(), forState: .Normal)
        button.setTitle(title, forState: .Normal)
        return button
    }
    
    func dictatorRoundCorners() {
        layer.cornerRadius = 25
    }
}

