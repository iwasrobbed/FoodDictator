//
//  TwitterManager.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation
import TwitterKit

typealias TwitterLoginSuccessBlock = (session: TWTRSession) -> Void
typealias TwitterAPISuccessBlock = (json: AnyObject) -> Void

typealias TwitterErrorBlock = (errorMessage: String) -> Void

typealias TwitterHumanBlock = (human: Human) -> Void
typealias TwitterHumansBlock = (humans: [Human]) -> Void

class TwitterManager {

    // MARK: - Lifecycle
    
    /**
     *  Singleton instance of the manager
     */
    static let sharedManager = TwitterManager()

    // MARK: - Public Properties

    /**
      The Twitter instance to start Fabric with
     */
    var twitterInstance: Twitter = {
        Twitter.sharedInstance().startWithConsumerKey("iAxE6aQd7rc5goYvgk5zrItiQ", consumerSecret: "shZu8IGP3bSgZRzYIHMe9tUEZPBJpdVBpMHOaw631pIhoSLgso")
        return Twitter.self()
    }()

    /**
      Whether the person has an active Twitter session
     */
    lazy var isLoggedIn: Bool = {
        return self.activeSession != nil
    }()

    /**
      The currently logged in human
     */
    var currentHuman: Human?

    // MARK: - Login

    /**
     Login to Twitter

     - parameter viewController: The view controller to launch login from
     - parameter success:        Called during a successful login with the result object given
     - parameter cancel:         Called if the person cancels
     - parameter error:          Called during an error or bad data event
     */
    func login(success: TwitterLoginSuccessBlock? = nil, error: TwitterErrorBlock? = nil) {
        twitterInstance.logInWithCompletion { (session: TWTRSession?, loginError: NSError?) in
            if let loginError = loginError {
                error?(errorMessage: loginError.localizedDescription)
                return
            }

            guard let session = session else {
                error?(errorMessage: TwitterLocalizations.BadLoginResultData)
                return
            }

            success?(session: session)
        }
    }

    /**
     Fetches the currently logged in person

     - parameter success: Called after a successful fetch with the human returned
     - parameter error:   Called during an error or bad data event
     */
    func fetchCurrentHuman(success: TwitterHumanBlock? = nil, error: TwitterErrorBlock? = nil) {
        guard let activeSession = activeSession else {
            fatalError("Can only call into Twitter API with an active session")
        }

        apiClient.loadUserWithID(activeSession.userID) { (user: TWTRUser?, fetchError: NSError?) in
            if let fetchError = fetchError {
                error?(errorMessage: fetchError.localizedDescription)
                return
            }

            guard let user = user else {
                error?(errorMessage: TwitterLocalizations.BadUserFetch)
                return
            }

            self.currentHuman = Human(fullName: user.name, screenName: user.screenName, photoURLString: user.profileImageLargeURL)
            success?(human: self.currentHuman!)
        }
    }

    /**
     Fetch the person's friends

     - parameter success: Called after a successful fetch with the humans returned
     - parameter error:   Called during an error or bad data event
     */
    func fetchFriends(success: TwitterHumansBlock? = nil, error: TwitterErrorBlock? = nil) {
        let endpoint = "https://api.twitter.com/1.1/friends/list.json?skip_status=true&include_user_entities=false"
        fetchHumansFromEndpoint(endpoint, success: success, error: error)
    }

    /**
     Search all Twitter users

     - parameter query:   The query to search with
     - parameter success: Called after a successful fetch with the human returned
     - parameter error:   Called during an error or bad data event
     */
    func searchUsers(query: String, success: TwitterHumansBlock? = nil, error: TwitterErrorBlock? = nil) {
        guard let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) else {
            fatalError("Malformed query string when calling into Twitter API")
        }
        let endpoint = "https://api.twitter.com/1.1/users/search.json?q=\(escapedQuery)"
        fetchHumansFromEndpoint(endpoint, success: success, error: error)
    }

    // MARK: - Private Properties

    lazy private var apiClient: TWTRAPIClient = {
        return TWTRAPIClient.clientWithCurrentUser()
    }()

    lazy private var activeSession: TWTRAuthSession? = {
        return self.twitterInstance.sessionStore.session()
    }()

}

private extension TwitterManager {

    func fetchFromAPI(endpoint: String, parameters: [String: AnyObject]?, success: TwitterAPISuccessBlock? = nil, error: TwitterErrorBlock? = nil) {
        let request = apiClient.URLRequestWithMethod("GET", URL: endpoint, parameters: parameters, error: nil)
        apiClient.sendTwitterRequest(request) { (response: NSURLResponse?, data: NSData?, connectionError: NSError?) -> Void in
            if let connectionError = connectionError {
                error?(errorMessage: connectionError.localizedDescription)
                return
            }

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                success?(json: json)
            } catch let jsonError as NSError {
                error?(errorMessage: jsonError.localizedDescription)
            }
        }
    }

    func fetchHumansFromEndpoint(endpoint: String, success: TwitterHumansBlock? = nil, error: TwitterErrorBlock? = nil) {
        fetchFromAPI(endpoint, parameters: nil, success: { (json) in
            guard let humans = self.humansFromTwitterJSON(json) else {
                error?(errorMessage: TwitterLocalizations.ErrorParsingJSON)
                return
            }
            success?(humans: humans)
        }, error: error)
    }

    func humansFromTwitterJSON(json: AnyObject) -> [Human]? {
        if let jsonArray = json as? [AnyObject] {
            return humansFromTwitterJSONArray(jsonArray)
        } else {
            guard let users = json["users"] as? [AnyObject] else { return nil }

            return humansFromTwitterJSONArray(users)
        }
    }

    func humansFromTwitterJSONArray(jsonArray: [AnyObject]) -> [Human]? {
        var humans = [Human]()
        for userDictionary in jsonArray {
            let userDictionary = userDictionary as! [NSObject: AnyObject]
            let twitterUser = TwitterUser(dictionary: userDictionary)
            humans.append(Human(fullName: twitterUser.name, screenName: twitterUser.screenName, photoURLString: twitterUser.photoURLString))
        }
        return humans
    }

}
