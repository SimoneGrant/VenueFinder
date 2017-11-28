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
    struct FS {
        static let baseURL = "https://api.foursquare.com/v2/venues/explore/"
        struct Queries {
            static let coords = "?ll="
            static let photoBool = "&venuePhotos=1"
            static let id = "&client_id="
            static let secret = "&client_secret="
            static let expiration = "&v=201811124"
            static let query = "&query=vegan"
            }
        }
    struct VegGuide {
        static let baseURL = "https://www.vegguide.org/search/"
        struct SearchBy {
            static let searchBy = "by-lat-long/"
            static let filter = "/filter/category_id=1;"
            static let vegLevel = "veg_level=4;"
            static let distance = "distance=2"
        }
    }
    struct Yelp {
        static let restaurantSearch = "https://api.yelp.com/v3/businesses/search?term=vegan"
        static let phoneSearchURL = "https://api.yelp.com/v3/businesses/search/phone?phone="
        static let businessURL = "https://api.yelp.com/v3/businesses/"
        static let restaurantNameSearch = "https://api.yelp.com/v3/businesses/search?"
        struct Filters {
            static let lat = "&latitude="
            static let lng = "&longitude="
            static let reviews = "/reviews"
            static let term = "?term="
        }
    }
}
