//
//  DictatorController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit

/*
 * The dictator has arisen!
 */

class DictatorController: BaseController {

    // MARK: - Lifecycle

    // TODO: Init with a human
    let human = Human()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        animateHat()
    }

    // MARK: - Private Properties

    let hatView = UIImageView(image: UIImage(named: "DictatorHat"))
    private var hatBottomConstraint: Constraint?

    let photoView = UIImageView()
    private let photoDiameter: CGFloat = 150
    let nameLabel = UILabel.dictatorHeader4Label("")

    lazy private var revoltButton: UIButton = {
        return UIButton.dictatorRounded(.Blue, title: DictatorLocalizations.REVOLT, target: self, action: #selector(DictatorController.revoltAgainstDictator))
    }()

    lazy private var restaurantsButton: UIButton = {
        // TODO: Set specific city or "nearby" one day
        let title = String(format: RestaurantLocalizations.CityRestaurantsFormat, arguments: ["San Jose"]).uppercaseString
        return UIButton.dictatorRounded(.Pink, title: title, target: self, action: #selector(DictatorController.viewRestaurants))
    }()

}

// MARK: - Private API

private extension DictatorController {

    // MARK: - View Setup

    func setupView() {
        setupNavigation(DictatorLocalizations.NEWDICTATOR, backButton: false)

        setupDictator()
        setupButtons()
    }

    func setupDictator() {
        view.addSubview(photoView)
        view.addSubview(hatView)
        view.addSubview(nameLabel)

        nameLabel.text = human.fullName

        photoView.image = human.photo
        photoView.backgroundColor = .grayColor()
        photoView.fullyRound(photoDiameter, borderColor: .dictatorLine(), borderWidth: 0.5)
        photoView.snp_makeConstraints { (make) in
            make.size.equalTo(photoDiameter)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp_centerY)
        }

        hatView.alpha = 0
        hatView.snp_makeConstraints { (make) in
            make.size.equalTo(CGSizeMake(120, 87))
            make.centerX.equalTo(photoView)
            hatBottomConstraint = make.bottom.equalTo(photoView.snp_top).offset(-50).constraint
        }

        nameLabel.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(view)
            make.centerX.equalTo(photoView)
            make.top.equalTo(photoView.snp_bottom).offset(5)
        }
    }

    func setupButtons() {
        view.addSubview(restaurantsButton)
        view.addSubview(revoltButton)

        restaurantsButton.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(UIButton.dictatorConfig.buttonWidthPercentage)
            make.bottom.equalTo(view).offset(-20)
            make.height.equalTo(UIButton.dictatorConfig.buttonHeight)
            make.centerX.equalTo(view)
        }

        revoltButton.snp_makeConstraints { (make) -> Void in
            make.width.centerX.height.equalTo(restaurantsButton)
            make.bottom.equalTo(restaurantsButton.snp_top).offset(-10)
        }
    }

    // MARK: - Actions

    @objc func revoltAgainstDictator() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @objc func viewRestaurants() {
        self.navigationController?.pushViewController(RestaurantsController(), animated: true)
    }

    // MARK: - Animations

    func animateHat() {
        view.layoutSubviews()

        self.hatBottomConstraint!.updateOffset(30)
        self.hatView.setNeedsLayout()

        UIView.animateWithDuration(0.5, delay: 0.5,
                                   usingSpringWithDamping: 0.5,
                                   initialSpringVelocity: 0.8,
                                   options: .CurveEaseIn,
                                   animations: { () -> Void in
                                    self.hatView.layoutIfNeeded()
                                    self.hatView.alpha = 1
            }, completion: nil)
    }

}