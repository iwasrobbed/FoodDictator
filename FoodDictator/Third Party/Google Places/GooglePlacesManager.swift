//
//  GooglePlacesManager.swift
//  FoodDictator
//
//  Created by Rob Phillips on 5/11/16.
//  Copyright © 2016 Viv Labs. All rights reserved.
//

import Foundation
import Alamofire

typealias GoogleErrorBlock = (_ errorMessage: String) -> Void
typealias GooglePlacesBlock = (_ places: [GooglePlace]) -> Void

enum GooglePlaceType {
    case restaurant

    func toString() -> String {
        switch self {
        case .restaurant:
            return "restaurant"
        }
    }
}

class GooglePlacesManager {

    // MARK: - Lifecycle

    /**
     *  Singleton instance of the manager
     */
    static let sharedManager = GooglePlacesManager()

    // MARK: - Fetching Places

    // Note: This is a very basic example with a fixed location (Viv), but if this were a production app
    // then you'd want to have bounded queries based on user location, place type, etc. and setup
    // a proper API client.

    /**
     Fetches all places near Viv of a given type and name

     - parameter query:   The restaurant name
     - parameter type:    The type of place from `GooglePlaceType`
     - parameter success: Block to call upon success
     - parameter error:   Block to call upon error
     
     Note: This is a very basic example with a fixed location (Viv), but if this were a production app
     then you'd want to have bounded queries based on user location, place type, etc. and setup
     a proper API client.
     */
    func fetchPlacesNearViv(_ query: String, type: GooglePlaceType = .restaurant, success: GooglePlacesBlock? = nil, error: GoogleErrorBlock? = nil) {
        let queryString = String(format: queryFormat, arguments: [pipedQueryFrom(query), type.toString(), radius, language, apiKey])
        guard let escapedQuery = queryString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            fatalError("Malformed query string when calling into Google Places API")
        }
        let endpoint = baseURL + escapedQuery

        Alamofire.request(endpoint, method: .get, parameters: nil).responseJSON { (response) in
            if let json = response.result.value {
                guard let json = json as? [String: AnyObject], let places = self.placesFromJSON(json) else {
                    error?("Could not parse JSON or it was empty")
                    return
                }
                
                success?(places)
            } else {
                guard let apiError = response.result.error else {
                    error?("Bad response")
                    return
                }
                
                error?(apiError.localizedDescription)
            }
        }
    }

    /**
      Cancels any Google Place API calls
     */
    func cancelAllFetches() {
//        Alamofire.Manager.sharedInstance.session.getTasksWithCompletionHandler { dataTasks, uploadTasks, downloadTasks in
//            for task in dataTasks {
//                if let originalRequest = task.originalRequest, originalRequest.URLString.containsString(self.baseURL) {
//                    task.cancel()
//                }
//            }
//        }
    }

    // MARK: - Private Properties

    // An alternative to hitting the API directly would be to use the Google Maps iOS SDK
    let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
    let queryFormat = "name=%@&type=%@&location=37.333906,-121.893895&radius=%lu&language=%@&key=%@"
    let apiKey = "AIzaSyDh_8cu7MvhaK3IynASryyc3QluE_x89f0"
    let radius = 8000 // ~5 miles
    let language = "en"

}

private extension GooglePlacesManager {

    func pipedQueryFrom(_ query: String) -> String {
        let queryTerms = query.components(separatedBy: " ")
        guard queryTerms.count > 1 else { return query }

        return queryTerms.joined(separator: "|")
    }

    func placesFromJSON(_ json: [String: AnyObject]) -> [GooglePlace]? {
        guard let results = json["results"] as? [AnyObject] else { return nil }
        guard results.count != 0 else { return nil }

        var places = [GooglePlace]()
        for placeDictionary in results {
            let placeDictionary = placeDictionary as! [String: AnyObject]
            places.append(GooglePlace(dictionary: placeDictionary as NSDictionary))
        }

        return places
    }

}
