//
//  AllMapView.swift
//  moonshot
//
//  Created by Adam on 29/04/2026.
//

import SwiftUI
import MapKit

struct AllMapView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var showingAlert = false
    
    // MARK: closures// computed properties
    var launchLocations: [Location] {
        var internalList: [Location] = []
        var nameList: [String] = []
        for mission in spaceDataStore.missions{
            if let thisPlace =  spaceDataStore.launchSites[mission.launchpad]  {
                if nameList.contains(thisPlace.displayName) == false
                {
                    internalList.append(thisPlace)
                    nameList.append(thisPlace.displayName)
                }
            }
        }
        return internalList
    }
    var landingLocations: [Location]{
        var internalList: [Location] = []
        var nameList: [String] = []
        for mission in spaceDataStore.missions{
            if let thisPlace =  spaceDataStore.landingSites[mission.landingSite ?? "error"]  {
                if nameList.contains(thisPlace.displayName) == false
                {
                    internalList.append(thisPlace)
                    nameList.append(thisPlace.displayName)
                }
            }
        }
        return internalList
    }

    var etLocations: [Location]{
        var internalList: [Location] = []
        var locEl: Location
        for mission in spaceDataStore.missions{
            if let impactLocation =  mission.etImpact  {
                
                if let tidyLong = Double(impactLocation.longitude){
                    if let tidyLat = Double(impactLocation.latitude){
                        locEl = Location(
                            displayName: mission.displayName + " ET impact",
                            coordinate: CLLocationCoordinate2D(
                                latitude: Double(tidyLat),
                                longitude: Double(tidyLong)
                            ),
                            type:  "ET impact"
                        )
                        internalList.append(locEl)
                    }
                }
            }
        }
        return internalList
    }
    var apolloImpacts: [Location] {
        // limit to apollo missions
        let apolloMissions = spaceDataStore.missions.filter {$0.program.hasPrefix("Apoll")}
        var internalList: [Location] = []
        for mission in apolloMissions {
            if let firstStage = mission.identifiedComponents?.filter({$0.description == "First Stage"})[0]{
                if let lat = firstStage.impactLat{
                    if let long = firstStage.impactLong{
                        if let thisLocation = mission.makeLocation(lat: lat, long: long, displayName: "", type:  ["Skylab 2", "Skylab 3", "Skylab 4", "ASTP", "Apollo 7"].contains(mission.displayName) ? "\(mission.displayName) S-IB Impact": "\(mission.displayName) S-IC Impact")
                        {
                            internalList.append(thisLocation)
                        }
                    }
                }
            }
            if let secondStage = mission.identifiedComponents?.filter({$0.description == "Second Stage"})[0]{
                if let lat = secondStage.impactLat{
                    if let long = secondStage.impactLong{
                        if let thisLocation = mission.makeLocation(lat: lat, long: long, displayName: "", type:  ["Skylab 2", "Skylab 3", "Skylab 4", "ASTP", "Apollo 7"].contains(mission.displayName) ? "\(mission.displayName) S-IVB Impact": "\(mission.displayName) S-II Impact")
                            
                        {
                            internalList.append(thisLocation)
                        }
                    }
                }
            }
            if let thirdStage = mission.identifiedComponents?.filter({$0.description == "Third Stage"}){
                if thirdStage.count > 0 {
                    let actualThirdStage = thirdStage[0]
                    if let lat = actualThirdStage.impactLat{
                        if let long = actualThirdStage.impactLong{
                            if let thisLocation = mission.makeLocation(lat: lat, long: long, displayName: "\(mission.displayName) SIV-B Impact", type: "")
                            {
                                internalList.append(thisLocation)
                            }
                        }
                    }
                }
            }
        }
        return internalList
    }
        
    // MARK: body here
    var body: some View {
        Map{
            ForEach(etLocations) {location in
                Marker(location.displayName, coordinate: location.coordinate) // marker = uses pin but can customise::
            } // foreach
            
            ForEach(launchLocations) {location in
                Marker(location.displayName, coordinate: location.coordinate) // marker = uses pin but can customise::
            } // foreach
            
            ForEach(landingLocations){location in
                Annotation(location.displayName, coordinate: location.coordinate){
                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundStyle( location.type == "reported" ? .red : .green)
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(.circle)
                        .onTapGesture{
                            showingAlert.toggle()
                        }
                }
            }
            ForEach(apolloImpacts){location in
                Annotation(location.displayName, coordinate: location.coordinate){
                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundStyle( .blue)
                        .frame(width: 24, height: 24)
                        .background(.white)
                        .clipShape(.circle)
                        .onTapGesture{
                            showingAlert.toggle()
                        }
                }
            }

        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    AllMapView().environmentObject(previewStore)
}


