//
//  SearchField.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit

typealias TextFieldBeginEditingBlock = () -> Void
typealias TextFieldEndEditingBlock = () -> Void
typealias TextFieldChangedBlock = (text: String) -> Void
typealias TextFieldCancelBlock = () -> Void

class TextField : UIView {

    struct height {
        static let standard: CGFloat = 50
        static let search: CGFloat = 40
    }
    struct widthMultiplier {
        static let standard = 0.85
        static let full = 0.95
    }

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

    // MARK: - Public Properties

    /**
      Gets called when the text field begins editing
     */
    var beginEditingBlock: TextFieldBeginEditingBlock?

    /**
      Gets called when the text changes
     */
    var changedBlock: TextFieldChangedBlock?

    /**
      Gets called when the text field ends editing
     */
    var endEditingBlock: TextFieldBeginEditingBlock?

    /**
      Gets called when the text field's cancel button is tapped
     */
    var cancelBlock: TextFieldCancelBlock?

    // MARK: - Lifecycle

    /**
     Instantiate a textfield with the given corner style and placeholder; defaults to .None corners

     - parameter cornerStyle: The `RoundedCornerStyle`
     - parameter placeholder: The placeholder

     - returns: A customized textfield
     */
    required init(cornerStyle: RoundedCornerStyle = .None, placeholder: String, cancellable: Bool = false) {
        super.init(frame: CGRectZero)

        setupView(cornerStyle, placeholder: placeholder, cancellable: cancellable)
        setupNotifications()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - First Responder

    override func isFirstResponder() -> Bool {
        return textField.isFirstResponder()
    }

    // MARK: - Rounding Corners

    // We do this since we need to wait for auto layout to draw
    override func drawRect(rect: CGRect) {
        let borderColor = UIColor.dictatorTextFieldBorder()
        let borderWidth: CGFloat = 1

        if let cornerRect = roundedCornerStyle!.toRectCorner() {
            container.round(cornerRect, radius: 10, borderColor: borderColor, borderWidth: borderWidth)
        } else {
            container.round([.TopLeft, .TopRight, .BottomLeft , .BottomRight], radius: 0, borderColor: borderColor, borderWidth: borderWidth)
        }
    }

    // MARK: - Private Properties

    private let container = UIView()
    private let textField = UITextField()
    lazy private var cancelButton: UIButton = {
        return UIButton.dictatorImageOnly(UIImage(named: "SearchCancel")!, target: self, action: #selector(TextField.cancelTapped))
    }()
    private var roundedCornerStyle : RoundedCornerStyle?

}

// MARK: - Private API

private extension TextField {

    // MARK: - View Setup

    func setupView(cornerStyle: RoundedCornerStyle = .None, placeholder: String, cancellable: Bool) {
        backgroundColor = UIColor.clearColor()
        roundedCornerStyle = cornerStyle

        container.backgroundColor = .dictatorTextField()
        addSubview(container)
        container.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        let cancelDiameter: CGFloat = 40
        if cancellable {
            container.addSubview(cancelButton)
            cancelButton.snp_makeConstraints(closure: { (make) in
                make.size.equalTo(cancelDiameter)
                make.centerY.right.equalTo(container)
            })
        }

        // TODO: Fix textfield not overflowing correctly
        textField.font = .dictatorTextField()
        textField.delegate = self
        textField.placeholder = placeholder
        textField.autocorrectionType = .No
        textField.autocapitalizationType = .None
        container.addSubview(textField)
        textField.snp_makeConstraints { (make) -> Void in
            let hPadding: CGFloat = 10
            let vPadding: CGFloat = 5
            let rightInset = cancellable ? cancelDiameter + hPadding : hPadding
            make.edges.equalTo(container).inset(UIEdgeInsetsMake(vPadding, hPadding, vPadding, rightInset))
        }
    }

    // MARK: - Notifications

    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TextField.textFieldDidChange), name: UITextFieldTextDidChangeNotification, object: nil)
    }

    // MARK: - Actions

    @objc func cancelTapped() {
        textField.text = ""
        textField.resignFirstResponder()

        cancelBlock?()
    }

}

// MARK: - UITextFieldDelegate & Notifications

extension TextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(textField: UITextField) {
        beginEditingBlock?()
    }

    func textFieldDidChange() {
        changedBlock?(text: textField.text!)
    }

    func textFieldDidEndEditing(textField: UITextField) {
        endEditingBlock?()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
