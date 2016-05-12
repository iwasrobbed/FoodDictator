//
//  GooglePlace.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import CottonObject

class GooglePlace: CottonObject {

    var name: String    { return stringForGetter(#function) }
    var rating: Float?  { return floatForGetter(#function) }
    var openNow: Bool? {
        let dictionary = self.dictionary as NSDictionary
        return dictionary.valueForKeyPath("opening_hours.open_now") as? Bool
    }

}