//
//  YelpModel.swift
//  HangryDraft
//
//  Created by Simone Grant on 11/9/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

//search for restaurants
struct RestaurantDetails: Decodable {
    let businesses: [Details]
}

struct Details: Decodable {
    let id: String
    let name: String
    let image_url: String
    let is_closed: Bool
    let categories: [Tags]
    let rating: Float
    let coordinates: Coordinates
    let price: String
    let location: DisplayLocation
    let phone: String
    let display_phone: String
}

//search by phone
struct Businesses: Decodable {
    let businesses: [BusinessItems]
}
struct BusinessItems: Decodable {
    let id: String
}

//search by id
struct VenueDetails: Decodable {
    let name: String
    let image_url: String
    let is_closed: Bool
    let display_phone: String
    let categories: [Tags]
    let location: DisplayLocation
    let coordinates: Coordinates
    let photos: [String]
    let price: String
    let hours: [Times]
}

struct Times: Decodable {
    let open: [Open]
}

struct Open: Decodable {
    let start: String
    let end: String
    let day: Int
}

struct Coordinates: Decodable {
    let latitude: Float
    let longitude: Float
}

struct DisplayLocation: Decodable {
    let formattedAddress: [String]?
}

struct Tags: Decodable {
    let title: String
}

//search by reviews
struct Reviews: Decodable {
    let reviews: [Review]
}

struct Review: Decodable {
    let text: String
    let rating: Int
    let time_created: String
}
