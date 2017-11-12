//
//  CustomNetwork.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/11/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

protocol CustomNetwork {
    func fourSquareURLString(latitude: Double, longitude: Double) -> String
    func vegGuideURLString(latitude: Double, longitude: Double) -> String
    func yelpLatLngSearchString(latitude: Double, longitude: Double) -> String
    func yelpSearchBy(phone: String, country: String) -> String
    func yelpSearchReviewsByVenue(ID: String) -> String
    func searchBy(venueID: String) -> String
}

//return url's for API request
extension CustomNetwork {
    
    func fourSquareURLString(latitude: Double, longitude: Double) -> String {
        return "\(Network.FS.baseURL)\(Network.FS.Queries.coords)\(latitude),\(longitude)\(Network.FS.Queries.photoBool)\(Network.FS.Queries.id)\(Auth.init().clientID)\(Network.FS.Queries.secret)\(Auth.init().clientSecret)\(Network.FS.Queries.expiration)\(Network.FS.Queries.query)"
    }
    
    func vegGuideURLString(latitude: Double, longitude: Double) -> String {
        return "\(Network.VegGuide.baseURL)\(Network.VegGuide.SearchBy.searchBy)\(latitude),\(longitude)\(Network.VegGuide.SearchBy.filter)\(Network.VegGuide.SearchBy.vegLevel)\(Network.VegGuide.SearchBy.distance)"
    }
    
    func yelpLatLngSearchString(latitude: Double, longitude: Double) -> String {
        return "\(Network.Yelp.restaurantSearch)\(Network.Yelp.Filters.lat)\(latitude)\(Network.Yelp.Filters.lng)\(longitude)"
    }
    
    func yelpSearchBy(phone: String, country: String) -> String {
        return "\(Network.Yelp.phoneSearchURL)\(country)\(phone)"
    }
    
    func yelpSearchReviewsByVenue(ID: String) -> String {
        return "\(Network.Yelp.businessURL)\(ID)\(Network.Yelp.Filters.reviews)"
    }
    
    func searchBy(venueID: String) -> String {
        return "\(Network.Yelp.businessURL)\(venueID)"
    }
}

class NetworkString: CustomNetwork {}

