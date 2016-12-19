//
//  BaseController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit

/**
 *  Configuration constants
 */
struct DictatorNavigationBar {
    static let height: CGFloat = 54
    static let buttonTopOffset: CGFloat = 17
    static let buttonEdgeSize: CGFloat = 30
}

/*
 * Base class to inherit common behavior / style from
 */

class BaseController: UIViewController {

    // MARK: - Public Properties

    lazy var navigationView = UIView()

    // MARK: - Public API

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    /**
     Sets up a navigation area with the given title and a back button

     - parameter title: The navigation title to display
     */
    func setupNavigation(_ title: String = "", backButton: Bool = true) {
        _setupNavigation(title, backButton: backButton)
    }

    // MARK: - Status Bar

    override var prefersStatusBarHidden : Bool {
        return true
    }

}

// MARK: - Private API

private extension BaseController {

    func setupView() {
        // We don't use the navigation bar as-is; we create our own
        navigationController?.isNavigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .dictatorWhite()
    }

    // MARK: - Custom Navigation Bar

    func _setupNavigation(_ title: String, backButton: Bool) {

        // Back button
        if backButton {
            let backButton = UIButton.dictatorBackButton(self, action: #selector(BaseController.backButtonTapped))
            navigationView.addSubview(backButton)
            backButton.snp.makeConstraints { (make) -> Void in
                make.size.equalTo(DictatorNavigationBar.buttonEdgeSize)
                make.left.equalTo(navigationView).offset(3)
                make.top.equalTo(navigationView).offset(DictatorNavigationBar.buttonTopOffset)
            }
        }

        // Title label
        if title != "" {
            let navLabel = UILabel.dictatorNavigationLabel(title)
            navigationView.addSubview(navLabel)
            navLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(40)
                // Leave room for potential nav buttons
                make.width.equalTo(navigationView).multipliedBy(0.8)
                make.top.equalTo(navigationView).offset(DictatorNavigationBar.buttonTopOffset - 6)
                make.centerX.equalTo(navigationView)
            }
        }

        // Setup container view
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(DictatorNavigationBar.height)
            make.top.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
        }
    }
    
    // MARK: - Actions
    
    @objc func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
