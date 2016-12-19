//
//  TwitterManager.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation
import TwitterKit

typealias TwitterLoginSuccessBlock = (_ session: TWTRSession) -> Void
typealias TwitterAPISuccessBlock = (_ json: AnyObject) -> Void

typealias TwitterErrorBlock = (_ errorMessage: String) -> Void

typealias TwitterHumanBlock = (_ human: Human) -> Void
typealias TwitterHumansBlock = (_ humans: [Human]) -> Void

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
        Twitter.sharedInstance().start(withConsumerKey: "iAxE6aQd7rc5goYvgk5zrItiQ", consumerSecret: "shZu8IGP3bSgZRzYIHMe9tUEZPBJpdVBpMHOaw631pIhoSLgso")
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
    func login(_ success: TwitterLoginSuccessBlock? = nil, error: TwitterErrorBlock? = nil) {
        twitterInstance.logIn { (session: TWTRSession?, loginError: NSError?) in
            if let loginError = loginError {
                error?(errorMessage: loginError.localizedDescription)
                return
            }

            guard let session = session else {
                error?(errorMessage: TwitterLocalizations.BadLoginResultData)
                return
            }

            self.activeSession = session
            success?(session: session)
        } as! TWTRLogInCompletion as! TWTRLogInCompletion as! TWTRLogInCompletion as! TWTRLogInCompletion as! TWTRLogInCompletion as! TWTRLogInCompletion as! TWTRLogInCompletion as! TWTRLogInCompletion
    }

    /**
      Logout the current session (removes from the keychain as well)
     */
    func logOut() {
        if let twitterUserID = twitterUserID {
            twitterInstance.sessionStore.logOutUserID(twitterUserID)
        }
    }

    /**
     Fetches the currently logged in person

     - parameter success: Called after a successful fetch with the human returned
     - parameter error:   Called during an error or bad data event
     */
    func fetchCurrentHuman(_ success: TwitterHumanBlock? = nil, error: TwitterErrorBlock? = nil) {
        guard let activeSession = activeSession else {
            fatalError("Can only call into Twitter API with an active session")
        }

        apiClient.loadUser(withID: activeSession.userID) { (user: TWTRUser?, fetchError: NSError?) in
            if let fetchError = fetchError {
                error?(errorMessage: fetchError.localizedDescription)
                return
            }

            guard let user = user else {
                error?(errorMessage: TwitterLocalizations.BadUserFetch)
                return
            }

            self.twitterUserID = user.userID
            self.currentHuman = Human(fullName: user.name, screenName: user.screenName, photoURLString: user.profileImageLargeURL)
            success?(human: self.currentHuman!)
        } as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion as! TWTRLoadUserCompletion
    }

    /**
     Fetch the person's friends

     - parameter success: Called after a successful fetch with the humans returned
     - parameter error:   Called during an error or bad data event
     */
    func fetchFriends(_ success: TwitterHumansBlock? = nil, error: TwitterErrorBlock? = nil) {
        let endpoint = "https://api.twitter.com/1.1/friends/list.json?skip_status=true&include_user_entities=false"
        fetchHumansFromEndpoint(endpoint, success: success, error: error)
    }

    /**
     Search all Twitter users

     - parameter query:   The query to search with
     - parameter success: Called after a successful fetch with the human returned
     - parameter error:   Called during an error or bad data event
     */
    func searchUsers(_ query: String, success: TwitterHumansBlock? = nil, error: TwitterErrorBlock? = nil) {
        guard let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            fatalError("Malformed query string when calling into Twitter API")
        }
        let endpoint = "https://api.twitter.com/1.1/users/search.json?q=\(escapedQuery)"
        fetchHumansFromEndpoint(endpoint, success: success, error: error)
    }

    // MARK: - Private Properties

    lazy fileprivate var apiClient: TWTRAPIClient = {
        return TWTRAPIClient.withCurrentUser()
    }()

    lazy fileprivate var activeSession: TWTRAuthSession? = {
        return self.twitterInstance.sessionStore.session()
    }()

    var twitterUserID: String?

}

private extension TwitterManager {

    func fetchFromAPI(_ endpoint: String, parameters: [String: AnyObject]?, success: TwitterAPISuccessBlock? = nil, error: TwitterErrorBlock? = nil) {
        let request = apiClient.urlRequest(withMethod: "GET", url: endpoint, parameters: parameters, error: nil)
        apiClient.sendTwitterRequest(request) { (response: URLResponse?, data: Data?, connectionError: NSError?) -> Void in
            if let connectionError = connectionError {
                error?(errorMessage: connectionError.localizedDescription)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                success?(json: json)
            } catch let jsonError as NSError {
                error?(errorMessage: jsonError.localizedDescription)
            }
        } as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion as! TWTRNetworkCompletion 
    }

    func fetchHumansFromEndpoint(_ endpoint: String, success: TwitterHumansBlock? = nil, error: TwitterErrorBlock? = nil) {
        fetchFromAPI(endpoint, parameters: nil, success: { (json) in
            guard let humans = self.humansFromTwitterJSON(json) else {
                error?(TwitterLocalizations.ErrorParsingJSON)
                return
            }
            success?(humans)
        }, error: error)
    }

    func humansFromTwitterJSON(_ json: AnyObject) -> [Human]? {
        if let jsonArray = json as? [AnyObject] {
            return humansFromTwitterJSONArray(jsonArray)
        } else {
            guard let users = json["users"] as? [AnyObject] else { return nil }

            return humansFromTwitterJSONArray(users)
        }
    }

    func humansFromTwitterJSONArray(_ jsonArray: [AnyObject]) -> [Human]? {
        var humans = [Human]()
        for userDictionary in jsonArray {
            let userDictionary = userDictionary as! [AnyHashable: Any]
            let twitterUser = TwitterUser(dictionary: userDictionary as NSDictionary)
            humans.append(Human(fullName: twitterUser.name, screenName: twitterUser.screenName, photoURLString: twitterUser.photoURLString))
        }
        return humans
    }

}
