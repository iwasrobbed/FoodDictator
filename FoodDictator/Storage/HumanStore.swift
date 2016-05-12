//
//  HumanStore.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/12/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation

class HumanStore {

    private let storageKey = "DictatorHumans"
    private let defaults = NSUserDefaults.standardUserDefaults()

    func store(human: Human) {
        var humans = retrieveAll() ?? Set<Human>()
        humans.insert(human)
        store(humans)
    }

    func retrieveAll() -> Set<Human>? {
        guard let data = defaults.dataForKey(storageKey) else { return nil }
        return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? Set<Human>
    }

    func remove(human: Human) {
        guard var humans = retrieveAll() else { return }
        humans.remove(human)
        store(humans)
    }

    func flush() {
        defaults.removeObjectForKey(storageKey)
        defaults.synchronize()
    }

}

private extension HumanStore {

    func store(humans: Set<Human>) {
        let data = NSKeyedArchiver.archivedDataWithRootObject(humans)
        defaults.setObject(data, forKey: storageKey)
        defaults.synchronize()
    }

}