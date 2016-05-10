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

    class func dictatorNavigationLabel(title: String) -> UILabel {
        return dictatorLabel(title.uppercaseString, font: .dictatorNavigationTitle(), color: .dictatorBlack(), alignment: .Center)
    }

    class func dictatorHeader4Label(title: String) -> UILabel {
        return dictatorLabel(title, font: .dictatorRegular(28), alignment: .Center)
    }

    class func dictatorRegularLabel(title: String) -> UILabel {
        let label = dictatorLabel(title, font: .dictatorRegular(18))
        label.lineBreakMode = .ByTruncatingTail
        label.numberOfLines = 1
        label.sizeToFit()
        return label
    }

    class func dictatorLabel(title: String, font: UIFont, color: UIColor = .dictatorBlack(), alignment: NSTextAlignment = .Left) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textAlignment = alignment
        label.textColor = color
        label.font = font
        label.numberOfLines = 0
        label.lineBreakMode = .ByWordWrapping
        label.sizeToFit()
        return label
    }
    
}
