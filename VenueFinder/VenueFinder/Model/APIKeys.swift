//
//  APIKeys.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/10/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

func valueForAPIKey(_ keyname: String) -> String {
    let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value: String = plist?.object(forKey: keyname) as! String
    return value
}
