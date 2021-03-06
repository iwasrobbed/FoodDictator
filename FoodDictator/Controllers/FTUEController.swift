//
//  FTUEController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit

/*
 * First time user experience where users can sign in
 */

class FTUEController: BaseController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    // MARK: - Private Properties

    fileprivate let dictatorLogo: UIImageView = {
        return UIImageView(image: UIImage(named: "LaunchLogo"))
    }()
    fileprivate var logoCenterYConstraint: Constraint?

    fileprivate let oneMealLabel: UILabel = {
        return UILabel.dictatorHeader4Label(FTUELocalizations.OneMealToRuleThemAll)
    }()

    fileprivate let gamesBeginLabel: UILabel = {
        return UILabel.dictatorLabel(FTUELocalizations.LetTheGamesBegin, font: .dictatorRegular(20), color: .dictatorGrayText(), alignment: .center)
    }()
    
    lazy fileprivate var signInButton: UIButton = {
        return UIButton.dictatorTwitter(self, action: #selector(FTUEController.signInTapped))
    }()

}

// MARK: - Private API

private extension FTUEController {

    // MARK: - View Setup

    func setupView() {
        setupLogoArea()
        setupButton()
        setupLabels()

        animateView()
    }

    func setupLogoArea() {
        view.addSubview(dictatorLogo)
        dictatorLogo.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
            logoCenterYConstraint = make.centerY.equalTo(view).constraint
        }
    }

    func setupButton() {
        signInButton.alpha = 0
        view.addSubview(signInButton)

        signInButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(UIButton.dictatorConfig.buttonWidthPercentage)
            make.bottom.equalTo(view).offset(-20)
            make.height.equalTo(UIButton.dictatorConfig.buttonHeight)
            make.centerX.equalTo(view)
        }
    }

    func setupLabels() {
        oneMealLabel.alpha = 0
        gamesBeginLabel.alpha = 0
        view.addSubview(oneMealLabel)
        view.addSubview(gamesBeginLabel)

        oneMealLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.height.equalTo(40)
            make.top.equalTo(dictatorLogo.snp.bottom).offset(30)
        }

        gamesBeginLabel.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(view)
            make.height.equalTo(30)
            make.bottom.equalTo(signInButton.snp.top).offset(-15)
        }
    }

    // MARK: - Animation

    func animateView() {
        view.layoutIfNeeded()

        logoCenterYConstraint!.update(offset: -50)
        dictatorLogo.setNeedsLayout()

        UIView.animate(withDuration: 1.1, delay: 0.5,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.8,
                                   options: UIViewAnimationOptions(),
                                   animations: { () -> Void in
                                    self.dictatorLogo.layoutIfNeeded()
            }, completion: nil)

        UIView.animate(withDuration: 0.3, delay: 0.65, options: .curveEaseIn, animations: { () -> Void in
            self.signInButton.alpha = 1
            self.oneMealLabel.alpha = 1
            self.gamesBeginLabel.alpha = 1
        }, completion: nil)
    }

    // MARK: - Actions
    
    @objc func signInTapped() {
        signInButton.isEnabled = false

        TwitterManager.sharedManager.login({ (session) in
            self.navigationController?.pushViewController(ChooseFriendsController(), animated: true)
        }) { (errorMessage) in
            self.signInButton.isEnabled = true
            self.showTwitterErrorMessage(errorMessage)
        }
    }

    // MARK - Alert

    func showTwitterErrorMessage(_ message: String) {
        let errorMessage = String(format: TwitterLocalizations.LoginErrorFormat, arguments: [message])
        AlertView.showErrorMessage(errorMessage, viewController: self)
    }
}
