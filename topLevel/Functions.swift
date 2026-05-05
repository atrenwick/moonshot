//
//  Functions.swift
//  moonshot
//
//  Created by Adam on 01/05/2026.
//

import Foundation
import SwiftUI

func calculateEndDate(launchDate: Date?, durationString: String) -> String {
    func parseDuration(_ string: String) -> DateComponents {
        var components = DateComponents()
        
        let parts = string.split(separator: " ")
        
        for part in parts {
            if part.hasSuffix("d") {
                components.day = Int(part.dropLast())
            } else if part.hasSuffix("h") {
                components.hour = Int(part.dropLast())
            } else if part.hasSuffix("m") {
                components.minute = Int(part.dropLast())
            } else if part.hasSuffix("s") {
                components.second = Int(part.dropLast())
            }
        }
        
        return components
    }
    
    func addDuration(
        //func to take a yyyy-MM-dd string, add a duration from date components and return the date after that duration
        launchDate: Date?,
        duration: DateComponents
    ) -> Date? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // avoids timezone surprises
        
        guard let startDate = launchDate else {
            return nil
        }
        
        return Calendar.current.date(byAdding: duration, to: startDate)
    }
 
    
    let theseComponents = parseDuration(durationString)
    let outputdate = addDuration(launchDate: launchDate, duration: theseComponents)
    
    
    var formattedOutputDate: String {
        outputdate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }

    return formattedOutputDate
}

func getMissionAsDuration(_ string: String) -> Duration {
    let parts = string.split(separator: " ")
    var myDuration: Duration = .zero
    
    for part in parts {
        let valueString = part.dropLast()
        // Safely parse the number; if it fails, skip this part
        guard let value = Int64(valueString) else { continue }
        
        if part.hasSuffix("d") {
            // Convert days to hours (1 day = 24 hours)
            myDuration = myDuration + Duration.seconds(value * 86400)
        } else if part.hasSuffix("h") {
            myDuration = myDuration +  Duration.seconds(value * 3600)
        } else if part.hasSuffix("m") {
            myDuration = myDuration +  Duration.seconds(value * 60)
        } else if part.hasSuffix("s") {
            myDuration = myDuration +  Duration.seconds(value)
        }
    }
    
    return myDuration
}


