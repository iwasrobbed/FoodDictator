//
//  TwitterUser.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import LazyObject

class TwitterUser: LazyObject {

    var name: String        { return try! objectFor(#function) }
    var screenName: String  { return try! objectFor("screen_name") }
    var photoURLString: String {
        let string: String = try! objectFor("profile_image_url")
        // Returns a larger image by removing the `normal` scoping
        return string.replacingOccurrences(of: "_normal.jpeg", with: ".jpeg")
    }
    
}
