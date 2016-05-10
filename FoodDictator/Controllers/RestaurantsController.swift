//
//  RestaurantsController.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import UIKit
import SnapKit

/*
 * Find scrumptious places to feast at
 */

class RestaurantsController: BaseController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

}

// MARK: - Private API

private extension RestaurantsController {

    // MARK: - View Setup

    func setupView() {
        // TODO: Set specific city or "nearby" one day
        let title = String(format: RestaurantLocalizations.CityRestaurantsFormat, arguments: ["SJ"]).uppercaseString
        setupNavigation(title)
    }
    
}