//
//  TimeCalculation.swift
//  VenueFinder
//
//  Created by Simone Grant on 11/16/17.
//  Copyright © 2017 Simone Grant. All rights reserved.
//

import Foundation

protocol TimeCalculation {
    func convertToReadableTime(_ time: String) -> String
    func getTime(_ time: String) -> String
    func getDayOfWeek() -> Int?
}

extension TimeCalculation {
    func convertToReadableTime(_ time: String) -> String {
        var convertedTime = Array(time)
        convertedTime.insert(":", at: 2)
        return String(convertedTime)
    }
    
    func getTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "h:mm a"
        var standardDate = ""
        if let newDate = date {
            standardDate = dateFormatter.string(from: newDate)
            print("12 hour formatted Date:", standardDate)
        }
        return standardDate
    }
    
    func getDayOfWeek() -> Int? {
        let todayDate = Date()
        let myCalendar = Calendar(identifier: .gregorian)
        let myComponents = myCalendar.component(.weekday, from: todayDate)
        let weekDay = myComponents
        return weekDay
    }
}

class Time: TimeCalculation {}
