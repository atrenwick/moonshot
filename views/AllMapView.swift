//
//  AllMapView.swift
//  moonshot
//
//  Created by Adam on 29/04/2026.
//
//MissionLocationView(locationType: "landing", location: previewStore.launchSites[firstMission.launchPad]!)

import SwiftUI
import MapKit

struct AllMapView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var showingAlert = false
    
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
    
    var body: some View {
        
        Map{
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
                            // TO DO : change this action to show list of missions that landed at this place if KSC or Edwards
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


