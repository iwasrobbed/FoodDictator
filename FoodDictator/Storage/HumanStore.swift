//
//  HumanStore.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/12/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation

class HumanStore {

    fileprivate let storageKey = "DictatorHumans"
    fileprivate let defaults = UserDefaults.standard

    func store(_ human: Human) {
        var humans = retrieveAll() ?? Set<Human>()
        humans.insert(human)
        store(humans)
    }

    func retrieveAll() -> Set<Human>? {
        guard let data = defaults.data(forKey: storageKey) else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? Set<Human>
    }

    func remove(_ human: Human) {
        guard var humans = retrieveAll() else { return }
        humans.remove(human)
        store(humans)
    }

    func flush() {
        defaults.removeObject(forKey: storageKey)
        defaults.synchronize()
    }

}

private extension HumanStore {

    func store(_ humans: Set<Human>) {
        let data = NSKeyedArchiver.archivedData(withRootObject: humans)
        defaults.set(data, forKey: storageKey)
        defaults.synchronize()
    }

}
