//
//  CostCategory.swift
//  VenueFinder
//
//  Created by Simone Grant on 1/1/18.
//  Copyright © 2018 Simone Grant. All rights reserved.
//

import Foundation

enum Cost {
    case cheap
    case moderate
    case expensive
    
    init?(price: String) {
        switch price {
        case "$":
            self = .cheap
        case "$$":
            self = .moderate
        case "$$$":
            self = .expensive
        default:
            self = .expensive
        }
    }
}


