//
//  MissionLocationView.swift
//  moonshot
//
//  Created by Adam on 28/04/2026.
//

import SwiftUI
import MapKit
//TODO: tweak needed to capitalisation on
    struct MissionLocationView: View {
    let locationType: String
    let location: Location
    let mission: Mission
    var titleChunk: String {
        var titleText: String = ""
        if locationType == "landing" {
            let precision = location.type == "reported" ? "at" : "at approx"
            if landingPrograms.contains(mission.program){
                titleText = "Landed \(precision) Lat. \(location.coordinate.latitude) Long. \(location.coordinate.longitude)"
            } else if splashdownPrograms.contains(mission.program){
                
                let header: String = locationType == "tank" ? "Tank impact @ ": "Splashdown at "

                let bulkText =  "Lat. \(location.coordinate.latitude) Long. \(location.coordinate.longitude)"
                    titleText = header + bulkText
            } else {
                titleText = "Lat. \(location.coordinate.latitude) Long. \(location.coordinate.longitude)"
            }
        } else if locationType == "launch"{
            titleText = "Launched from \(mission.launchpad)"
        }
        return titleText
    }
    // titleText
    var titleText: String{
        var returnText: String = ""
        if locationType == "launch" {
            returnText = "Launchpad: \(location.displayName)"
        } else {
            returnText = titleChunk
        }
        return returnText
    }
    // ll delta
    var lldelta: Double {
        if locationType == "launch"{
            return 0.05
        } else {
            return 70.0
        }
    }
    
    var myImage: String {
        // settings for launch
        if locationType == "launch" {
            return "star.circle"
        }
        else if locationType == "landing" {
            return "star"
        } else {
            return "fuelpump.fill"
        }
    }
    
    var body: some View {
        
        
        Text(titleText)
        let targetPosition  = MapCameraPosition.region(
            MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: lldelta, longitudeDelta: lldelta)
            )
        )
        Map(initialPosition : targetPosition){
            Annotation(location.displayName, coordinate: location.coordinate){
                Image(systemName: myImage)
                    .resizable()
                    .foregroundStyle( location.type == "reported" ? .red : .green)
                    .frame(width: 24, height: 24)
                    .background(.white)
                    .clipShape(.circle)
            }
            if mission.program == "Apollo" {
                if let lat = mission.reeentryLat {
                    if let long = mission.reentryLong {
                        if let eiLocationCoord = mission.makeLocation(lat: String(lat), long: String(long), displayName: "Entry interface", type: "reentry")?.coordinate {
                            Annotation("Entry Interface", coordinate: eiLocationCoord){Image(systemName:"star.square")}
                        }
                    }
                }
            }
            
        }.mapStyle(.imagery)
            .frame(minHeight: 300)
    }
}


#Preview {
    let previewStore = SpaceDataStore()
    let thisMission = previewStore.missions.filter({$0.displayName == "Apollo 12"})
        
    if thisMission.count > 0
    {
        MissionLocationView(locationType: "landing", location: previewStore.landingSites[thisMission[0].landingSite!]!, mission: thisMission[0])
            .environmentObject(previewStore)
        } else {
            Text("No missions found in preview store.")
        }
    
}
