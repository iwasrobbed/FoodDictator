//
//  TwitterUser.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import CottonObject

class TwitterUser: CottonObject {

    var name: String        { return stringForGetter(#function) }
    var screenName: String  { return stringForKey("screen_name") }
    var photoURLString: String {
        // Returns a larger image by removing the `normal` scoping
        return stringForKey("profile_image_url").stringByReplacingOccurrencesOfString("_normal.jpeg", withString: ".jpeg")
    }
    
}