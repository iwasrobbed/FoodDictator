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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

}

// MARK: - Private API

private extension DictatorController {

    // MARK: - View Setup

    func setupView() {
        setupNavigation(DictatorLocalizations.NEWDICTATOR, backButton: false)
    }
    
}