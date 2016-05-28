//
//  GooglePlace.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import LazyObject

class GooglePlace: LazyObject {

    var name: String    { return try! objectFor(#function) }
    var rating: Float?  { return try? objectFor(#function) }
    var openNow: Bool?  { return try? objectFor("opening_hours.open_now") }

}