//
//  DictatorController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import AVFoundation

/*
 * The dictator has arisen!
 */

class DictatorController: BaseController {

    // MARK: - Lifecycle

    required init(human: Human) {
        self.human = human

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        playTrumpet()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animateHat()
    }

    // MARK: - Private Properties

    fileprivate var human: Human

    fileprivate let hatView = UIImageView(image: UIImage(named: "DictatorHat"))
    fileprivate var hatBottomConstraint: Constraint?

    fileprivate let photoView = UIImageView()
    fileprivate let photoDiameter: CGFloat = 150
    fileprivate let nameLabel = UILabel.dictatorHeader4Label("")

    lazy fileprivate var revoltButton: UIButton = {
        return UIButton.dictatorRounded(.blue, title: DictatorLocalizations.REVOLT, target: self, action: #selector(DictatorController.revoltAgainstDictator))
    }()

    lazy fileprivate var restaurantsButton: UIButton = {
        // TODO: Set specific city or "nearby" one day
        let title = String(format: RestaurantLocalizations.CityRestaurantsFormat, arguments: ["San Jose"]).uppercased()
        return UIButton.dictatorRounded(.pink, title: title, target: self, action: #selector(DictatorController.viewRestaurants))
    }()

    var player: AVAudioPlayer?

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

        photoView.sd_setImage(with: human.photoURL)
        photoView.backgroundColor = .gray
        photoView.fullyRound(photoDiameter, borderColor: .dictatorLine(), borderWidth: 0.5)
        photoView.snp.makeConstraints { (make) in
            make.size.equalTo(photoDiameter)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view.snp.centerY)
        }

        hatView.alpha = 0
        hatView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 120, height: 87))
            make.centerX.equalTo(photoView)
            hatBottomConstraint = make.bottom.equalTo(photoView.snp.top).offset(-50).constraint
        }

        nameLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
            make.width.equalTo(view)
            make.centerX.equalTo(photoView)
            make.top.equalTo(photoView.snp.bottom).offset(5)
        }
    }

    func setupButtons() {
        view.addSubview(restaurantsButton)
        view.addSubview(revoltButton)

        restaurantsButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(UIButton.dictatorConfig.buttonWidthPercentage)
            make.bottom.equalTo(view).offset(-20)
            make.height.equalTo(UIButton.dictatorConfig.buttonHeight)
            make.centerX.equalTo(view)
        }

        revoltButton.snp.makeConstraints { (make) -> Void in
            make.width.centerX.height.equalTo(restaurantsButton)
            make.bottom.equalTo(restaurantsButton.snp.top).offset(-10)
        }
    }

    // MARK: - Actions

    @objc func revoltAgainstDictator() {
        _ = navigationController?.popViewController(animated: true)
    }

    @objc func viewRestaurants() {
        navigationController?.pushViewController(RestaurantsController(), animated: true)
    }

    // MARK: - Animations

    func animateHat() {
        view.layoutIfNeeded()

        hatBottomConstraint!.update(offset: 30)
        hatView.setNeedsLayout()

        UIView.animate(withDuration: 0.75, delay: 0.5,
                                   usingSpringWithDamping: 0.75,
                                   initialSpringVelocity: 0.8,
                                   options: .curveEaseIn,
                                   animations: { () -> Void in
                                    self.hatView.layoutIfNeeded()
                                    self.hatView.alpha = 1
            }, completion: nil)
    }

    // MARK: - Audio

    func playTrumpet() {
        let url = Bundle.main.url(forResource: "tada", withExtension: "mp3")!

        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }

            let currentTime = player.deviceCurrentTime
            player.prepareToPlay()
            player.play(atTime: currentTime + 0.5)
        } catch let error as NSError {
            print(error.description)
        }
    }

}
