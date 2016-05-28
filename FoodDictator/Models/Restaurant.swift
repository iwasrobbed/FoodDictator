//
//  Restaurant.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import LazyObject

class Restaurant: LazyObject {

    var name: String    { return try! objectFor(APIJSONKeys.name) }
    var rating: Float?  { return try? objectFor(APIJSONKeys.rating) }
    var openNow: Bool?  { return try? objectFor(APIJSONKeys.openNow) }

    // MARK: - Instantiation

    required init(name: String, rating: Float?, openNow: Bool?) {
        let dictionary = [APIJSONKeys.name : name] as NSMutableDictionary
        if let rating = rating { dictionary[APIJSONKeys.rating] = rating }
        if let openNow = openNow { dictionary[APIJSONKeys.openNow] = openNow }

        super.init(dictionary: dictionary, pruneNullValues: true)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init(dictionary: NSDictionary, pruneNullValues: Bool) { fatalError("init(dictionary:pruneNullValues:) has not been implemented") }

}