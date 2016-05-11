//
//  Restaurant.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation
import SwiftRandom

class Restaurant {

    var name = Randoms.randomFakeName()
    var photo = Restaurant.randomPhoto()
    
}

private extension Restaurant {

    class func randomPhoto() -> UIImage {
        let names = ["face1", "face2", "face3", "face4", "face5", "face6"]
        return UIImage(named: names.randomItem())!
    }

}