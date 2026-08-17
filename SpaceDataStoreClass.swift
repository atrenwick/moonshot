//
//  SpaceDataStoreClass.swift
//  
//
//  Created by Adam on 16/08/2026.
//

import Foundation
import SwiftUI
import Combine
import MapKit

class SpaceDataStore: ObservableObject {
    // @Published tells views to update when this changes
    @Published var missions: [Mission] = []
    @Published var spacewalks: [String: Spacewalk] = [:]
    @Published var astronauts: [String: Astronaut] = [:]
    @Published var sortedAstronauts = []
    @Published var spacecrafts: Dictionary<String,Spacecraft> = [:]
    @Published var astronautMissionsDict: Dictionary<String,[Mission]> = [:]
    @Published var groupedMissions: Dictionary<String,[Mission]> = [:]
    @Published var launchSites: [String: Location] = [:]
    @Published var landingSites: [String: Location] = [:]
    @Published var expeditions: [String: Expedition] = [:]
    @Published var subsidiarySpaceCrafts: [String: SubsidiarySpaceCraft] = [:]
    @Published var flightPhases: [PhaseDataRoot] = []
    @Published var referenceDocuments: [RefDoc] = []

    init() {
        // init data here
        let missionsUnsorted:[Mission] = Bundle.main.decode("missions.json")
        let decodedFlightPhases: PhaseDataRoot = Bundle.main.decode("phaseData.json")
        self.flightPhases = [decodedFlightPhases]
        self.missions = missionsUnsorted.sorted {$0.launchDate! < $1.launchDate!}
        self.groupedMissions = Dictionary(grouping: missions) {$0.program}
        self.spacewalks = Bundle.main.decode("spacewalks.json")
        self.referenceDocuments = Bundle.main.decode("referenceDocuments.json")

        var precalcAstronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
        for (key, value) in precalcAstronauts {
            var updatedValue = value
            var spacewalkCountInt: Int = 0
            var flightCountInt: Int = 0
            for mission in self.missions {
                for crewmember in mission.crew {
                    if crewmember.name == value.id {
                        flightCountInt += 1
                    }
                }
            }
            for spacewalk in self.spacewalks {
                for spacewalker in spacewalk.value.spacewalkers {
                    if spacewalker.name == value.id {
                        spacewalkCountInt += 1
                    }
                }
            }
            if spacewalkCountInt > 0 {
                updatedValue.spacewalkCount = spacewalkCountInt
            }
            if flightCountInt > 0 {
                updatedValue.spaceflightCount = flightCountInt
            }
            if flightCountInt + spacewalkCountInt > 0 {
            precalcAstronauts[key] = updatedValue
            }
        }
        
        self.astronauts = precalcAstronauts
        self.expeditions = Bundle.main.decode("expeditions.json")
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
        
        //MARK: initialise astronauts
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
}


