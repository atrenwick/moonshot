//
//  Functions.swift
//  moonshot
//
//  Created by Adam on 01/05/2026.
//

import Foundation
import SwiftUI
internal import _LocationEssentials

func calculateEndDate(launchDate: Date?, durationString: String) -> String {
    func parseDuration(_ string: String) -> DateComponents {
        var components = DateComponents()
        let parts = string.split(separator: " ")
        if parts.count > 1 {
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
        }
        return components
    }

    func addDuration(launchDate: Date?,duration: DateComponents) -> Date? {
        //func to take a yyyy-MM-dd string, add a duration from date components and return the date after that duration
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
        guard let value = Int(valueString) else { continue }
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


func getDurationFromString(_ string: String) -> (String, Duration){
    let parts = string.split(separator: ":")
    var myDuration: Duration = .zero
    
    var multipliers:Dictionary<Int,Int> = [:]
    multipliers[0] = 86400
    multipliers[1] = 3600
    multipliers[2] = 60
    multipliers[3] = 1
    
    for part in parts.enumerated() {
        let valueString = part
        // Safely parse the number; if it fails, skip this part
        guard let value = Int(valueString.1) else { continue }
        myDuration += Duration.seconds(value * Int(multipliers[part.0]!))
    }
    let returnString = myDuration.formatted(.units(allowed: [.days, .hours, .minutes, .seconds]))
    return (returnString, myDuration)
}

func makeListName(key: String, astronaut: Astronaut)-> String {

    // special cases:: ids ::: albassam, alsaud, vandenberg, williamsd,vanhoften,gardnerd,allenj
    // make names for list view : order and tweaking capitalisation
    var newSurname = astronaut.printSurname
    // Mcdonald needs the 3rd char capitalised ; need to operate with indices, not raw positions

    if newSurname.hasPrefix("Mc"){
        // i is the index of the 3rd char
        let i = newSurname.index(newSurname.startIndex, offsetBy: 2)
        // replace strings in range i thru i, with: uppercase of string i
        newSurname.replaceSubrange(i...i, with: String(newSurname[i]).uppercased())    }
    // since surname is now first, remove from initial position and tidy

    let modName = astronaut.name
        .replacing(astronaut.printSurname, with:"")
        .replacing(" Jr.", with:" (Jr.)")
        .replacing(" , ", with:" ")
        .replacing("  ", with:" ")
    
    var outputString = newSurname + ", " + String(modName.first ?? "X") + "."
    if astronaut.printSurname == "Voss" {
        if astronaut.name.contains("James"){
            outputString = outputString.replacing("J.",with:"J.S.")
        } else {
            outputString = outputString.replacing("J.", with:"J.E.")
        }
    }
    if astronaut.printSurname == "Johnson" {
        if astronaut.name.contains("Gregory H"){
            outputString = outputString.replacing("G.",with:"G.H.")
        } else {
            outputString = outputString.replacing("G.", with:"G.C.")
        }
    }
    return outputString
}

func describeStack(identifiedComponent: IdentifiedComponent) -> String {

    let identifiedComponent: IdentifiedComponent = identifiedComponent
    var descriptionString: String {
        return identifiedComponent.description + " : " + identifiedComponent.serial
        }
    return descriptionString
}

func getExpeditionSpacewalkers(theseSpacewalks: [Spacewalk], expedition: Expedition) -> [String] {
    var theseSpacewalkers: [String] = []
    for currSpacewalk in theseSpacewalks {
            for innerLevel in currSpacewalk.spacewalkers {
                if theseSpacewalkers.contains(innerLevel.name) == false {
                    theseSpacewalkers.append(innerLevel.name)
                }
            }
        }
    let spacewalkerNames = Array(Set(theseSpacewalkers)).sorted {$0 < $1}
    return spacewalkerNames
}

func getLandingSiteShort(spaceDataStore: SpaceDataStore, mission: Mission) -> String {
    // actions
    var thisString: String
    let missionLS = mission.landingSite
    var thisRunway: String = ""
    if mission.program == "Space Shuttle" {
        if let useRunway = mission.runway{
            thisRunway = useRunway
        }
    }
    if mission.program != "Space Shuttle"{
        if let landingDetail: Location =   spaceDataStore.landingSites[missionLS ?? "x"] {
            let latMeasurement = Measurement(value: landingDetail.coordinate.latitude, unit: UnitAngle.degrees)
            let lonMeasurement = Measurement(value: landingDetail.coordinate.longitude, unit: UnitAngle.degrees)
            
            let formatter = MeasurementFormatter()
            formatter.unitStyle = .medium
            formatter.numberFormatter.maximumFractionDigits = 2
            
            var latString = formatter.string(from: latMeasurement)
            var lonString = formatter.string(from: lonMeasurement)
            if latString.hasPrefix("-"){
                latString = latString.replacing("-",with:"S ")
            } else {
                latString = "N " + latString
            }
            if lonString.hasPrefix("-"){
                lonString = lonString.replacing("-",with:"W ")
            } else {
                lonString = "E " + lonString
            }
            thisString = latString + ", " + lonString
            thisString = thisString.replacing(" deg", with:"")
        }
        else {
            thisString = "error"
        }
    }
    else {
        let foreString = spaceDataStore.landingSites[missionLS ?? "x"]?.displayName ?? "x"
        thisString = "\(foreString) Runway \(thisRunway)"
    }
    return thisString
}

// alternative method of calculating flight count, spacewalk count :
// function
//
//    func recomputeCounts() {
//        // flight counts
//        var counts: [String: Int] = [:]
//
//        for mission in self.missions {
//            for crewmember in mission.crew {
//                counts[crewmember.name, default: 0] += 1
//            }
//        }
//
//        flightCounts = counts
//        // spacewalk counts
//        var swCounts: [String: Int] = [:]
//        for spacewalk in self.spacewalks{
//            for spacewalker in spacewalk.value.spacewalkers {
//                swCounts[spacewalker.name, default: 0] += 1
//            }
//        }
//        spacewalkCounts = swCounts
//    }
// in moonshot.App, in the Class:: instantiate published var missions, with didset to run recmpute counts
//@Published var missions: [Mission] = [] //{
//        didSet {
//            recomputeCounts()
//        }
//    }
//
// then add element to published data:: .flightcounts of string: int to allow lookups
//    @Published private(set) var flightCounts: [String: Int] = [:] // TODO: tweak these to set the value in teh Astronaut struct

//unused::
//func getImageDims(imageName: String) -> (Int, Int){
//    var width: Int = 0
//    var height: Int = 0
//    var uiImage: UIImage? {UIImage(named: imageName)}
//    if let size = uiImage?.size{
//        width = Int(size.width * (uiImage?.scale ?? 1))
//        height = Int(size.height * (uiImage?.scale ?? 1))
//    }
//    let returnItem = (width,height)
//    return returnItem
//}

