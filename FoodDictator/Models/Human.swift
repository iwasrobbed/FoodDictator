//
//  Human.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation
import SwiftRandom

class Human {

    var firstName = Human.randomFirstName()
    var lastName = Human.randomLastName()
    var photo = Human.randomPhoto()

    lazy var fullName: String = {
        return "\(self.firstName) \(self.lastName)"
    }()

}

private extension Human {

    class func randomFirstName() -> String {
        let firstNameList = ["Henry", "William", "Geoffrey", "Jim", "Yvonne", "Jamie", "Leticia", "Priscilla", "Sidney", "Nancy", "Edmund", "Bill", "Megan"]
        return firstNameList.randomItem()
    }

    class func randomLastName() -> String {
        let lastNameList = ["Pearson", "Adams", "Cole", "Francis", "Andrews", "Casey", "Gross", "Lane", "Thomas", "Patrick", "Strickland", "Nicolas", "Freeman"]
        return lastNameList.randomItem()
    }

    class func randomPhoto() -> UIImage {
        let names = ["face1", "face2", "face3", "face4", "face5", "face6"]
        return UIImage(named: names.randomItem())!
    }
    
}
