//
//  UILabel+Dictator.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

// MARK: - Public API

extension UILabel {

    class func dictatorNavigationLabel(_ title: String) -> UILabel {
        return dictatorLabel(title.uppercased(), font: .dictatorNavigationTitle(), color: .dictatorBlack(), alignment: .center)
    }

    class func dictatorHeader4Label(_ title: String) -> UILabel {
        return dictatorLabel(title, font: .dictatorRegular(28), alignment: .center)
    }

    class func dictatorRegularLabel(_ title: String) -> UILabel {
        let label = dictatorLabel(title, font: .dictatorRegular(18))
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }

    class func dictatorLabel(_ title: String, font: UIFont, color: UIColor = .dictatorBlack(), alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = alignment
        label.textColor = color
        label.font = font
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }
    
}
