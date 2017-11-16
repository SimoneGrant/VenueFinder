//
//  GetCountryCodes.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/16/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

class GetCountry {
    static func getCountryCode(_ country: String) -> String {
        var code = ""
        let filteredResults = Countries.allCountries.filter( { $0.country == country } )
        for x in filteredResults {
            code = x.callCode
        }
        if country.characters.count == 2 {
            let shortResult = Countries.allCountries.filter( {$0.shortAbbreviation == country })
            for x in shortResult {
                code = x.callCode
            }
        }
        if country.characters.count == 3 {
            let longerResult = Countries.allCountries.filter( {$0.longAbbreviation == country })
            for x in longerResult {
                code = x.callCode
            }
        }
        return code
    }
}
