//
//  RestaurantFSModel.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

struct Response: Decodable {
    let response: ResponseItems
}

struct ResponseItems: Decodable {
    let headerFullLocation: String
    let groups: [Groups]
}

struct Groups: Decodable {
    let items: [Items]
}

struct Items: Decodable {
    let venue: Venue
}

struct Venue: Decodable {
    let name: String
    let contact: Contact
    let location: Location
    let categories: [Categories]
    let url: String?
    let price: Price?
    let rating: Double
    let photos: Photos?
    let hours: Hours?
    let menu: Menu?
}

struct Contact: Decodable {
    let phone: String?
    let formattedPhone: String?
}

struct Location: Decodable {
    let lat: Float
    let lng: Float
    let address: String
    let postalCode: String?
    let city: String
    let state: String
    let country: String
}

struct Categories: Decodable {
    let name: String
    let icon: Icon
}

struct Icon: Decodable {
    let prefix: String
    let suffix: String
}

struct Price: Decodable {
    let currency: String
}

struct Menu: Decodable {
    let mobileUrl: String
}

struct Hours: Decodable {
    let isOpen: Bool
}

struct Photos: Decodable {
    let groups: [PhotoItems]
}

struct PhotoItems: Decodable {
    let items: [PhotoData]
}

struct PhotoData: Decodable {
    let prefix: String
    let suffix: String
    let width: Int
    let height: Int
}
