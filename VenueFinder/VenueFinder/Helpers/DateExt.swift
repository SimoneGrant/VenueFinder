//
//  DateExt.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/17/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

extension Date {
    func compareTimes(hours: Int, minutes: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = calendar.dateComponents([.hour,  .minute], from: self)
        dateComponents.hour = hours
        dateComponents.minute = minutes
        let newDate = calendar.date(from: dateComponents)!
        return newDate
    }
}
