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
typealias TextFieldChangedBlock = (_ text: String) -> Void
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
        case top, bottom, all, none

        func toRectCorner() -> UIRectCorner? {
            switch self {
            case .top:
                return [.topLeft , .topRight]
            case .bottom:
                return [.bottomLeft , .bottomRight]
            case .all:
                return [.topLeft , .topRight, .bottomLeft, .bottomRight]
            case .none:
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
    required init(cornerStyle: RoundedCornerStyle = .none, placeholder: String, cancellable: Bool = false) {
        super.init(frame: CGRect.zero)

        setupView(cornerStyle, placeholder: placeholder, cancellable: cancellable)
        setupNotifications()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - First Responder

    override var isFirstResponder : Bool {
        return textField.isFirstResponder
    }

    // MARK: - Rounding Corners

    // We do this since we need to wait for auto layout to draw
    override func draw(_ rect: CGRect) {
        let borderColor = UIColor.dictatorTextFieldBorder()
        let borderWidth: CGFloat = 1

        if let cornerRect = roundedCornerStyle!.toRectCorner() {
            container.round(cornerRect, radius: 10, borderColor: borderColor, borderWidth: borderWidth)
        } else {
            container.round([.topLeft, .topRight, .bottomLeft , .bottomRight], radius: 0, borderColor: borderColor, borderWidth: borderWidth)
        }
    }

    // MARK: - Private Properties

    fileprivate let container = UIView()
    fileprivate let textField = UITextField()
    lazy fileprivate var cancelButton: UIButton = {
        let button = UIButton.dictatorImageOnly(UIImage(named: "SearchCancel")!, target: self, action: #selector(TextField.cancelTapped))
        button.isEnabled = false
        return button
    }()
    fileprivate var roundedCornerStyle : RoundedCornerStyle?

}

// MARK: - Private API

fileprivate extension TextField {

    // MARK: - View Setup

    func setupView(_ cornerStyle: RoundedCornerStyle = .none, placeholder: String, cancellable: Bool) {
        backgroundColor = UIColor.clear
        roundedCornerStyle = cornerStyle

        container.backgroundColor = .dictatorTextField()
        addSubview(container)
        container.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }

        let cancelDiameter: CGFloat = 40
        if cancellable {
            container.addSubview(cancelButton)
            cancelButton.snp.makeConstraints({ (make) in
                make.size.equalTo(cancelDiameter)
                make.centerY.right.equalTo(container)
            })
        }

        textField.font = .dictatorTextField()
        textField.delegate = self
        textField.placeholder = placeholder
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        container.addSubview(textField)
        textField.snp.makeConstraints { (make) -> Void in
            let hPadding: CGFloat = 10
            let vPadding: CGFloat = 5
            let rightInset = cancellable ? cancelDiameter + hPadding : hPadding
            make.edges.equalTo(container).inset(UIEdgeInsetsMake(vPadding, hPadding, vPadding, rightInset))
        }
    }

    // MARK: - Notifications

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(TextField.textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }

    // MARK: - Actions

    @objc func cancelTapped() {
        textField.text = ""
        textField.resignFirstResponder()
        cancelButton.isEnabled = false

        cancelBlock?()
    }

}

// MARK: - UITextFieldDelegate & Notifications

extension TextField: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        beginEditingBlock?()

        cancelButton.isEnabled = true
    }

    func textFieldDidChange() {
        cancelButton.isEnabled = textField.isFirstResponder

        changedBlock?(textField.text!)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditingBlock?()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
