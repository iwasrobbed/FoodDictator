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
        case pink, blue

        func toColor() -> UIColor {
            switch self {
            case .pink:
                return UIColor.dictatorPink()
            case .blue:
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
    class func dictatorRounded(_ style: dictatorButtonStyle, title: String, target: AnyObject, action: Selector) -> UIButton {
        let button = dictatorGenericButton(title, target: target, action: action)
        button.backgroundColor = style.toColor()
        button.dictatorRoundCorners()
        button.titleLabel?.font = UIFont.dictatorRoundedButton()
        return button
    }

    /**
     Creates a button for logging in with Twitter

     - parameter target: Class to target
     - parameter action: Function to call upon touch up inside

     - returns: A Twitter login button
     */
    class func dictatorTwitter(_ target: AnyObject, action: Selector) -> UIButton {
        let button = dictatorRounded(.pink, title: FTUELocalizations.TWITTER, target: target, action: action)
        button.setImage(UIImage(named: "TwitterLogo"), for: UIControlState())
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
    class func dictatorImageOnly(_ image: UIImage, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: UIControlState())
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }

    /**
     Creates a navigation back button

     - parameter target: Class to target
     - parameter action: Function to call upon touch up inside

     - returns: A navigation back button with the given color
     */
    class func dictatorBackButton(_ target: AnyObject, action: Selector) -> UIButton {
        return dictatorImageOnly(UIImage(named: "BackArrowBlack")!, target: target, action: action)
    }

    // Dim buttons on disable
    override open var isEnabled: Bool {
        didSet { alpha = isEnabled ? 1 : 0.5 }
    }
}

// MARK: - Private API

private extension UIButton {

    class func dictatorGenericButton(_ title: String, target: AnyObject, action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(target, action: action, for: .touchUpInside)
        button.setTitleColor(.dictatorWhite(), for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0)
        return button
    }
    
    func dictatorRoundCorners() {
        layer.cornerRadius = 25
    }
}

