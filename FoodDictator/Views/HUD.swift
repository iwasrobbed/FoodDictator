//
//  HUD.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/12/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SwiftyGif

class HUD: NSObject {

    // MARK: - Actions

    /**
     Show the HUD
     */
    func show() {
        animate(showing: true)
    }

    /**
     Hide the HUD
     */
    func hide() {
        animate(showing: false)
    }

    // MARK: - Public Properties

    /**
     Whether or not the HUD is currently showing
     */
    var isShowing = false

    // MARK: - Lifecycle

    override init() {
        super.init()

        self.setupView()
    }

    // MARK: - Private Properties

    lazy private var overlayView: UIControl = {
        let view = UIControl(frame: UIScreen.mainScreen().bounds)
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.backgroundColor = UIColor.clearColor()
        view.alpha = 0
        return view
    }()

    lazy private var hud: UIView = {
        let hud = UIView()
        hud.backgroundColor = .dictatorWhite()
        hud.alpha = 0
        return hud
    }()

    private var wasAddedToMainWindow = false
    private let gifManager = SwiftyGifManager(memoryLimit:10) // mb
}

private extension HUD {

    // MARK: - View Setup

    func setupView() {
        addOverlayToKeyWindow()
        setupHUD()
    }

    func addOverlayToKeyWindow() {
        let windows = UIApplication.sharedApplication().windows.reverse()
        for window in windows {
            let windowIsOnScreen = window.screen == UIScreen.mainScreen()
            let windowIsVisible = !window.hidden && window.alpha > 0
            let windowIsNormalLevel = window.windowLevel == UIWindowLevelNormal

            if windowIsOnScreen && windowIsVisible && windowIsNormalLevel {
                window.addSubview(overlayView)
                wasAddedToMainWindow = true
            }
        }
    }

    func setupHUD() {
        let diameter: CGFloat = 60
        overlayView.addSubview(hud)
        hud.fullyRound(diameter, borderColor: .dictatorLine(), borderWidth: 0.5)
        hud.snp_makeConstraints { (make) in
            make.size.equalTo(diameter)
            make.center.equalTo(overlayView)
        }

        let gif = UIImage(gifName: "Rubiks")
        let gifView = UIImageView(gifImage: gif, manager: self.gifManager)
        hud.addSubview(gifView)
        gifView.snp_makeConstraints { (make) in
            make.size.equalTo(50)
            make.center.equalTo(hud)
        }
    }

    // MARK: - Animations

    func animate(showing showing: Bool) {
        isShowing = showing

        if !wasAddedToMainWindow {
            addOverlayToKeyWindow()
        }

        UIView.animateWithDuration(0.3, delay: 0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0.8,
                                   options: [.CurveEaseInOut, .BeginFromCurrentState],
                                   animations: { () -> Void in
                                    self.hud.alpha = showing ? 1 : 0
                                    self.overlayView.alpha = showing ? 1 : 0
                                    self.overlayView.backgroundColor = showing ? UIColor(white: 0, alpha: 0.1) : .clearColor()
            }, completion: nil)
    }
}