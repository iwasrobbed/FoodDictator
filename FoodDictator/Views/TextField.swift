//
//  TextField.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

class TextField : UIView {

    struct height {
        static let standard: CGFloat = 50
        static let search: CGFloat = 40
    }
    struct widthMultiplier {
        static let standard = 0.85
        static let full = 0.95
    }

    private let container = UIView()
    private let textField = UITextField()
    private var roundedCornerStyle : RoundedCornerStyle?

    enum RoundedCornerStyle: Int {
        case Top, Bottom, All, None

        func toRectCorner() -> UIRectCorner? {
            switch self {
            case .Top:
                return [.TopLeft , .TopRight]
            case .Bottom:
                return [.BottomLeft , .BottomRight]
            case .All:
                return [.TopLeft , .TopRight, .BottomLeft, .BottomRight]
            case .None:
                return nil
            }
        }
    }

    // MARK: - Lifecycle

    /**
     Instantiate a textfield with the given corner style and placeholder; defaults to .None corners

     - parameter cornerStyle: The `RoundedCornerStyle`
     - parameter placeholder: The placeholder

     - returns: A customized textfield
     */
    init(cornerStyle: RoundedCornerStyle = .None, placeholder: String) {
        super.init(frame: CGRectZero)

        setupView(cornerStyle, placeholder: placeholder)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - First Responder

    override func isFirstResponder() -> Bool {
        return textField.isFirstResponder()
    }

    // MARK: - Rounding Corners

    // We do this since we need to wait for auto layout to draw
    override func drawRect(rect: CGRect) {
        let borderColor = UIColor.dictatorTextFieldBorder()
        let borderWidth : CGFloat = 1

        if let cornerRect = roundedCornerStyle!.toRectCorner() {
            container.round(cornerRect, radius: 10, borderColor: borderColor, borderWidth: borderWidth)
        } else {
            container.round([.TopLeft, .TopRight, .BottomLeft , .BottomRight], radius: 0, borderColor: borderColor, borderWidth: borderWidth)
        }
    }

}

// MARK: - Private API

private extension TextField {

    // MARK: - View Setup

    func setupView(cornerStyle: RoundedCornerStyle = .None, placeholder: String) {
        backgroundColor = UIColor.clearColor()
        roundedCornerStyle = cornerStyle

        container.backgroundColor = .dictatorTextField()
        addSubview(container)
        container.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        textField.font = .dictatorTextField()
        textField.delegate = self
        textField.placeholder = placeholder
        container.addSubview(textField)
        textField.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(container).inset(UIEdgeInsetsMake(10, 20, 10, 20))
        }
    }

}

// MARK: - UITextFieldDelegate

extension TextField: UITextFieldDelegate {

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
