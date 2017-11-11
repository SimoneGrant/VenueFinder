//
//  Helpers.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation
import UIKit

//auth
struct Auth {
    let clientID = valueForAPIKey("CLIENT_ID")
    let clientSecret = valueForAPIKey("CLIENT_SECRET")
    let yelpID = valueForAPIKey("YELP_CLIENT_ID")
    let yelpClientSecret = valueForAPIKey("YELP_CLIENT_SECRET")
    let yelpToken = valueForAPIKey("YELP_TOKEN")
}

struct Network {
    struct FourSquare {
        static let baseURL = "https://api.foursquare.com/v2/venues/explore/"
    }
    struct VegGuide {
        static let baseURL = "https://www.vegguide.org/search/"
    }
    struct Yelp {
        static let restaurantSearch = "https://api.yelp.com/v3/businesses/search?term=vegan"
        static let phoneSearchURL = "https://api.yelp.com/v3/businesses/search/phone?phone="
        static let businessURL = "https://api.yelp.com/v3/businesses/"
    }
}


