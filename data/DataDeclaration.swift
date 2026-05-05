//
//  DataDeclaration.swift
//  moonshot
//
//  Created by Adam on 27/04/2026.
//

import Foundation
import MapKit
let launchLocations: Dictionary<String,Location> = [
    "KSCLC34":Location(displayName:"KSC LC34", coordinate: CLLocationCoordinate2D(latitude: 28.521944, longitude: -80.561389), type: "reported"),
    "KSCLC39A":Location(displayName:"KSC LC39A", coordinate: CLLocationCoordinate2D(latitude: 28.608294979166, longitude: -80.60413849818285), type: "reported"),
    "KSCLC39B":Location(displayName:"KSC LC39B", coordinate: CLLocationCoordinate2D(latitude: 28.627222, longitude: -80.620833), type: "reported"),
    "KSCLC19":Location(displayName:"KSC LC19", coordinate: CLLocationCoordinate2D(latitude: 28.506667, longitude: -80.554167), type: "reported"),
    "KSCLC5":Location(displayName:"KSCLC5",     coordinate: CLLocationCoordinate2D(latitude: 28.439444, longitude:  -80.573333), type: "reported"),
    "KSCLC14":Location(displayName:"KSCLC14", coordinate: CLLocationCoordinate2D(latitude: 28.491111,  longitude: -80.546944), type: "reported"),
    "KSCLC40":Location(displayName:"KSCLC40", coordinate: CLLocationCoordinate2D(latitude: 28.5619,  longitude: -80.5772), type: "reported"),
    "KSCLC41":Location(displayName:"KSCLC41", coordinate: CLLocationCoordinate2D(latitude: 28.583333,  longitude: -80.583056), type: "reported")
    ]


            
            

            
let spacePrograms = ["Mercury", "Gemini", "Apollo", "Apollo Applications", "Space Shuttle", "Commercial Crew", "Artemis"]
let orderedKey = spacePrograms

let spaceProgramsRU = ["Vostok","Voskhod", "Soyuz", "Soyuz-T", "Soyuz-TM" ,"Soyuz-TMA","Soyuz-MS"]
