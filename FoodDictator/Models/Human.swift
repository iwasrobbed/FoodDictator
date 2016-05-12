//
//  Human.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import CottonObject

class Human: CottonObject {

    // MARK: - Properties

    var isSelected = false

    var fullName: String    { return self.stringForKey(APIJSONKeys.fullName) }
    var screenName: String  { return self.stringForKey(APIJSONKeys.screenName) }
    var photoURL: NSURL     { return self.urlForKey(APIJSONKeys.photoURL) }

    // MARK: - Instantiation

    required init(fullName: String, screenName: String, photoURL: NSURL) {
        super.init(dictionary: [APIJSONKeys.fullName: fullName,
                                APIJSONKeys.screenName: screenName,
                                APIJSONKeys.photoURL : photoURL], removeNullKeys: true)
    }

    convenience init(fullName: String, screenName: String, photoURLString: String) {
        self.init(fullName: fullName, screenName: screenName, photoURL: NSURL(string: photoURLString)!)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - Equality

extension Human {

    override func isEqual(object: AnyObject?) -> Bool {
        if object == nil {
            return false
        }

        // Check if it's even a human object
        if let otherHuman = object as? Human {
            return screenName == otherHuman.screenName
        }

        return false
    }
}