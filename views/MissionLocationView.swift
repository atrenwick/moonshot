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
//    let missionLocation: MissionLocation
    let location: Location
    
    var titleChunk: String {
        var titleText: String = ""
        if ["edwards", "white sands", "KSLF"].contains(location.displayName){
            titleText =  "Landed at \(location.displayName )"
        } else {
           titleText = "Slashdown at Lat. \(location.coordinate.latitude) Long. \(location.coordinate.longitude)"
        }
        return titleText
    }
    
    var body: some View {

        let titleText = locationType == "launch" ? "Launchpad: \(location.displayName)" : titleChunk
        Text(titleText)
        let lldelta = locationType == "launch" ? 0.05 : 70.0
        let myImage = locationType == "launch" ? "star.circle" : "star"
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
        }.mapStyle(.imagery)
        .frame(minHeight: 300)
    }
}


#Preview {
    let previewStore = SpaceDataStore()
    if let firstMission = previewStore.missions.first {
        MissionLocationView(locationType: "landing", location: previewStore.launchSites[firstMission.launchpad]!)
            .environmentObject(previewStore)
        } else {
            Text("No missions found in preview store.")
        }
    
}
