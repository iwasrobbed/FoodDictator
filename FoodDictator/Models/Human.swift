//
//  Human.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/10/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import LazyObject

class Human: NSObject, LazyMapping, NSCoding {

    var dictionary: NSMutableDictionary

    // MARK: - Properties

    var fullName: String    { return try! objectFor(APIJSONKeys.fullName) }
    var screenName: String  { return try! objectFor(APIJSONKeys.screenName) }
    var photoURL: URL     { return try! objectFor(APIJSONKeys.photoURL) }

    // MARK: - Instantiation

    required convenience init(fullName: String, screenName: String, photoURL: URL) {
        let dictionary = [APIJSONKeys.fullName: fullName,
                          APIJSONKeys.screenName: screenName,
                          APIJSONKeys.photoURL : photoURL] as [String : Any]
        self.init(dictionary: dictionary as NSDictionary, pruneNullValues: true)
    }

    convenience init(fullName: String, screenName: String, photoURLString: String) {
        self.init(fullName: fullName, screenName: screenName, photoURL: URL(string: photoURLString)!)
    }

    required init(dictionary: NSDictionary, pruneNullValues: Bool = true) {
        self.dictionary = NSMutableDictionary(dictionary: pruneNullValues ? dictionary.pruneNullValues() : dictionary)
    }

    // MARK: - NSCoding

    @objc func encode(with aCoder: NSCoder) {
        dictionary.encode(with: aCoder)
    }

    @objc required convenience init?(coder aDecoder: NSCoder) {
        guard let dictionary = NSDictionary(coder: aDecoder) else { return nil }
        self.init(dictionary: dictionary, pruneNullValues: true)
    }

}

// MARK: - Equality

extension Human {

    override func isEqual(_ object: Any?) -> Bool {
        if object == nil {
            return false
        }

        // Check if it's even a human object
        if let otherHuman = object as? Human {
            return screenName == otherHuman.screenName
        }

        return false
    }

    override var hash: Int {
        return screenName.hash
    }

}
