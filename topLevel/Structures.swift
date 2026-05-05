//
//  Structures.swift
//  moonshot
//
//  Created by Adam on 13/04/2026.
//

import Foundation
import SwiftUI
import MapKit

//TODO : tweak this struct for astronauts to add calculated property of missions
//@EnvironmentObject var spaceDataStore =

struct Astronaut: Codable, Identifiable{
    let id: String
    let name: String
    let description: String
    let group: String
    let printSurname: String
    //let remoteImage: String?
    
}
// compute flightCounts
struct Mission: Codable, Identifiable {
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let name: String // name of mission
    let callsign: String // callsign
    let spacecraft: String // name of spacecraft
    let launchpad: String
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let backupcrew: [CrewRole]
    let description: String
    let program: String
    let sortOrder: Int
    let duration: String
    let landingSite: String?
    let hasSubsidiarySpaceCraft: Bool
    let subsidiarySpaceCraft: SubsidiarySpaceCraft?
    
    var displayName: String{
        
        if id < 18 {
            "Apollo \(id)"
        } else if [18,19,20].contains(id) {
            "Skylab \(id-16)"
        } else if id == 21 {
            "Apollo-Soyuz"
        } else if [22,23,24,26,27,28,29,30,31].contains(id) {
            "Gemini \(id - 19)"
        } else if id == 25 {
            "Gemini 6A"
        } else if program == "Mercury" {
            name.replacing("7", with: " 7").localizedCapitalized.replacing("bell ", with:" Bell ")
        }
        else {
                name
        }
        
    }
    var image: String {
        
        if id < 18 {
            "apollo\(id)"
        } else if [18,19,20].contains(id) {
            "skylab\(id-16)"
        } else if id == 21 {
            "astp"
        } else if id > 21 && id < 31 {
            "gemini\(id - 19)"
        } else {
            name
        }
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}

struct SubsidiarySpaceCraft: Codable, Identifiable, Hashable{
    enum CodingKeys: String, CodingKey, Codable{
        case spacecraft = "spacecraft"
        case spacecraftName = "spacecraftName"
        case type = "type"
        case id = "id"
    }
    var id: Int
    let spacecraft: String   // LM3, LM4
    let spacecraftName: String // callsign
    let type: String

    func hash(into hasher: inout Hasher){
        hasher.combine(spacecraftName)
    }
    
    static func == (lhs: SubsidiarySpaceCraft, rhs: SubsidiarySpaceCraft)-> Bool {
        return lhs.spacecraft == rhs.spacecraft
    }
    
}

struct Spacecraft: Codable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey, Codable {
        case location = "location"
        case spacecraft = "spacecraft"
        case id = "id"
        case program = "program"
        case spacecraftName = "callsign"
        case flightTime = "flightTime"
        case flightHours = "flightHours"
        case distance = "distance"
        case orbits = "orbits"
    }
    
    let id: Int
    let location: String
    let spacecraft: String
    let spacecraftName: String
    let program: String
    let flightTime: String?
    let flightHours: Int?
    let distance: Int?
    let orbits: Int?

    // 1. customisation of hasher to specify which fields should be examined when hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(spacecraftName)
    }
    // 2. Define the equality logic based on the hashed info : compare only the hashed fields we're interested in
    static func == (lhs: Spacecraft, rhs: Spacecraft) -> Bool {
        return lhs.spacecraftName == rhs.spacecraftName
    }
}


//Color-theme
// extend shape style only where it's being used as a colour
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground: Color{
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
    
}

func makeListName(key: String, astronaut: Astronaut)-> String {

    // special cases:: ids ::: albassam, alsaud, vandenberg, williamsd,vanhoften,gardnerd,allenj
    // make names for list view : order and tweaking capitalisation
    // capitalise Keys - these were used for sort order
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
struct Location: Identifiable {
    //struct to turn mission locations into map friendly items
    let id = UUID()
    var displayName: String
    var coordinate: CLLocationCoordinate2D
    let type: String
}

struct MissionLocation: Codable {
    //struct to decode the source json files
    let displayName: String
    let latitude: String
    let longitude: String
    let type: String
}
