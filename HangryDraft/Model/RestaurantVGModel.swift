//
//  RestaurantVGModel.swift
//  HangryDraft
//
//  Created by Simone Grant on 11/4/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

struct EntryItems: Decodable {
    let entries: [Entries]
}

struct Entries: Decodable {
    let distance: Float
    let website: String?
    let veg_level_description: String
    let long_description: LongDescription?
    let reviews_uri: String
    let city: String
    let postal_code: String?
    let neighborhood: String?
    let price_range: String
    let images: [Images]?
    let hours: [Schedule]?
    let name: String
    let region: String
    let categories: [String]
    let weighted_rating: String?
    let phone: String?
    let tags: [String]?
    let short_description: String
    let address1: String
    
}

struct LongDescription: Decodable {
    let wikitext: String
    private enum CodingKeys: String, CodingKey {
        case wikitext = "text/vnd.vegguide.org-wikitext"
    }
}

struct Images: Decodable {
    let files: [Files]
}

struct Files: Decodable {
    let uri: String
}

struct Schedule: Decodable {
    let hours: [String]
    let days: String
}

