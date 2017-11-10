//
//  APIKeys.swift
//  HangryDraft
//
//  Created by Simone Grant on 10/30/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

//API key wrapper

func valueForAPIKey(_ keyname: String) -> String {
    //get the filename keys.plist
    let filePath = Bundle.main.path(forResource: "keys", ofType: "plist")
    //read the dict
    let plist = NSDictionary(contentsOfFile: filePath!)
    //pull values from dict
    let value: String = plist?.object(forKey: keyname) as! String
    return value
}
