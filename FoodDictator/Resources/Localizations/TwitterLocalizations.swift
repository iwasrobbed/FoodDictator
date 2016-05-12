//
//  TwitterLocalizations.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation

public struct TwitterLocalizations {

    static let BadLoginResultData = NSLocalizedString("We received some bad data while trying to log you in with Twitter. Please hang up and try again.", comment: "")
    static let LoginErrorFormat = NSLocalizedString("There was an error logging you in: %@", comment: "There was an error logging you in: We failed you and we're sorry")
    static let FetchFriendsErrorFormat = NSLocalizedString("There was an error fetching friends: %@", comment: "There was an error fetching friends: We failed you and we're sorry")

    static let BadUserFetch = NSLocalizedString("No user was returned in the fetch :(", comment: "")
    static let ErrorParsingJSON = NSLocalizedString("Error parsing Twitter JSON", comment: "")

}