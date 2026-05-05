//
//  moonshotv2.swift
//  moonshot
//
//  Created by Adam on 15/04/2026.
//

import Foundation
import SwiftUI
import Combine
import MapKit


// create observable object for all data

class SpaceDataStore: ObservableObject {
    // @Published tells views to update when this changes
    @Published var missions: [Mission] = [] {
        didSet {
            recomputeCounts()
        }
    }
    @Published var astronauts: [String: Astronaut] = [:] {
        didSet {
            recomputeCounts()
        }
    }
    @Published var sortedAstronauts = []
    @Published var spacecrafts: Dictionary<String,Spacecraft> = [:]
    @Published var astronautMissionsDict: Dictionary<String,[Mission]> = [:]
    @Published private(set) var flightCounts: [String: Int] = [:]
    @Published var groupedMissions: Dictionary<String,[Mission]> = [:]
    @Published var launchSites: [String: Location] = [:]
    @Published var landingSites: [String: Location] = [:]
    @Published var subsidiarySpaceCrafts: [String: SubsidiarySpaceCraft] = [:]

    init() {
        // init data here
        let missionsUnsorted:[Mission] = Bundle.main.decode("missions.json")
        self.missions = missionsUnsorted.sorted {$0.launchDate! < $1.launchDate!}
        self.groupedMissions = Dictionary(grouping: missions) {$0.program}
        
        self.astronauts = Bundle.main.decode("astronauts.json") // decode json
        
        var allSortedAstronautsArray: [(key: String, value: Astronaut)] =
            astronauts.sorted { $0.key < $1.key }
        self.sortedAstronauts = allSortedAstronautsArray
        self.spacecrafts = Bundle.main.decode("spacecraft.json") // decode json
        
        self.subsidiarySpaceCrafts = Bundle.main.decode("subsidiarySpacecraft.json")
        
        //MARK: init for launch sites
        let launchSitesRaw: [String: MissionLocation] = Bundle.main.decode("launchsites.json")
        var launchSitesTidy: [String: Location] = [:]
        for thisKey in launchSitesRaw.keys {
            let sitename = thisKey
            let locEl = Location(
//                name: sitename,
                displayName : launchSitesRaw[thisKey]!.displayName,
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(launchSitesRaw[thisKey]!.latitude)!,
                    longitude: Double(launchSitesRaw[thisKey]!.longitude)!),
                type: launchSitesRaw[thisKey]!.type
                )
            launchSitesTidy[sitename] = locEl
        }
        self.launchSites = launchSitesTidy

        //MARK: init for landing sites
        let landingSitesRaw : [String: MissionLocation] = Bundle.main.decode("landingSites.json")
        var landingSitesTidy: [String: Location] = [:]
        for thisKey in landingSitesRaw.keys{
            let sitename = thisKey
            let locEl = Location(
                displayName: landingSitesRaw[thisKey]!.displayName,
                coordinate: CLLocationCoordinate2D(
                    latitude: Double(landingSitesRaw[thisKey]!.latitude)!,
                    longitude: Double(landingSitesRaw[thisKey]!.longitude)!),
                type:  landingSitesRaw[thisKey]!.type
            )
            landingSitesTidy[sitename] = locEl
        }
        self.landingSites = landingSitesTidy
        
        for thisAstronaut in astronauts {
            let thisKey = thisAstronaut.key
            let theseMissions = missions.filter { mission in
                mission.crew.contains{ crewMember in
                    crewMember.name == thisKey
                }
            }
            if theseMissions.count > 0 {
                astronautMissionsDict[thisKey] = theseMissions
            } else {
                let theseMissions = missions.filter { mission in
                    mission.backupcrew.contains{ crewMember in
                        crewMember.name == thisKey
                    }
                }
                if theseMissions.count > 0 {
                    astronautMissionsDict[thisKey] = theseMissions
                    
                } else {
                    astronautMissionsDict[thisKey] = []
                }
                
            }
        }
        self.astronautMissionsDict = astronautMissionsDict
    }

    
    
    func recomputeCounts() {
        var counts: [String: Int] = [:]
        
        for mission in self.missions {
            for crewmember in mission.crew {
                counts[crewmember.name, default: 0] += 1
            }
        }
        
        flightCounts = counts
    }
}

// mainAPP
@main
struct moonshotApp: App {
    @StateObject var spaceDataStore = SpaceDataStore()   // make state object from class instance
    
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Missions", systemImage: "book.pages.fill" ){
                    ContentView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Astronauts", systemImage: "person" ){
                    AstronautListView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Spacecraft", image: "rocket" ){
                    SpacecraftListView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                }
                Tab("Map", systemImage: "globe" ){
                    AllMapView()
                        .environmentObject(spaceDataStore)  // add datastore to environemnt, so directly callable from all views
                                    }

            }
        }
    }
}


