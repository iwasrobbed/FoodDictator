//
//  Restaurant.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import CottonObject

class Restaurant: CottonObject {

    var name: String    { return self.stringForKey(APIJSONKeys.name) }
    var rating: Float?  { return self.floatForKey(APIJSONKeys.rating) }
    var openNow: Bool?  { return self.boolForKey(APIJSONKeys.openNow) }

    // MARK: - Instantiation

    required init(name: String, rating: Float?, openNow: Bool?) {
        var dictionary = [APIJSONKeys.name : name]
        if let rating = rating { dictionary[APIJSONKeys.rating] = String(rating) }
        if let openNow = openNow { dictionary[APIJSONKeys.openNow] = String(openNow) }

        super.init(dictionary: dictionary, removeNullKeys: true)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}