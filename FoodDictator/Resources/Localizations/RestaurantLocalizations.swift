//
//  RestaurantLocalizations.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation

public struct RestaurantLocalizations {

    static let CityRestaurantsFormat = NSLocalizedString("%@ Restaurants", comment: "e.g. San Jose Restaurants")

    static let SearchPlaceholder = NSLocalizedString("Search near Viv", comment: "")

    static let hoursNA = NSLocalizedString("hours n/a", comment: "hours not available")
    static let openNow = NSLocalizedString("open now", comment: "")
    static let closed = NSLocalizedString("closed", comment: "")
    static let ratingNA = NSLocalizedString("rating n/a", comment: "rating not available")
    static let ratingFormat = NSLocalizedString("rating: %.1f", comment: "rating: 4.5")

}