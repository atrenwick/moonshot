//
//  GenericCapsuleLaunchView.swift
//  moonshot
//
//  Created by Adam on 04/06/2026.
//

import SwiftUI
import MapKit

struct GenericCapsuleLaunchView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State private var selectedMapType: MapTypeSelection = .imagery

    let mission: Mission

    var body: some View {
        //Text("This is a Russian mission, default units == metric")
        if let launchLocation = spaceDataStore.launchSites[mission.launchpad]{
            
            let targetPosition  = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: launchLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70)
                )
            )
            Map(initialPosition : targetPosition){
                
                Annotation(launchLocation.displayName, coordinate: launchLocation.coordinate) {
                    Image(systemName: "star.circle.fill") // Your special SF Symbol for the target
                        .font(.title)
                        .foregroundColor(.green) // Make it stand out from the rest
                        .background(Circle().fill(.white))
                        .clipShape(.capsule)
                        .overlay(
                            Capsule()
                                .strokeBorder(.white, lineWidth: 1)
                        )
                }
            }.mapStyle(selectedMapType.mapKitStyle)
                .safeAreaInset(edge: .bottom) {
                    Picker("Map Type", selection: $selectedMapType) {
                        ForEach(MapTypeSelection.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 0)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .frame(minHeight: 300)
            
            //MARK : list
            List{
                StatsRepeatableElement(
                    item: mission.getFormattedDate(inputDate: mission.launchDate),
                    label: "Launch date"
                )
                StatsRepeatableElement(
                    item: spaceDataStore.launchSites[mission.launchpad]?.displayName ?? "UNK",
                    label: "Launchpad")
                StatsRepeatableElement(item: mission.spacecraft, label: "Spacecraft")
                StatsRepeatableElement(
                    item: mission.getMeasurementString(
                        thisInt: mission.launchMass,
                        type: .mass,
                        sourceUnit: mission.launchMassUnit ?? mission.programDefaultMass
                    ),
                    label: "Launch mass")

                if let azimuthValue =  mission.flightAzimuth{
                    StatsRepeatableElement(item: azimuthValue,
                    label: "Launch azimuth",
                    append: "˚",
                    withSeparator: false)
                }

//                StatsRepeatableElement(
//                    item: mission.describeOrbit(
//                        sMajor: mission.orbitSmaj,
//                        sMinor: mission.orbitSmin,
//                        inputUnit: mission.orbitSmajUnit ?? mission.programDefaultLength
//                    ) ?? "Unknown orbit",
//                    label: "Orbit")
//                StatsRepeatableElement(
//                    item: mission.orbitalInclination,
//                    label: "Orbital Inclination",
//                append: "˚",
//                withSeparator: false)
//                StatsRepeatableElement(
//                    item: mission.getMeasurementString(thisInt: mission.landingMass, type: .mass, sourceUnit: mission.landingMassUnit ?? mission.programDefaultMass) ,
//                    label: "Landing mass")
            }.frame(minHeight: 400)
        }
    }
}


#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("Soyuz 8")}
    if theseMissions.count > 0 {
        GenericCapsuleLaunchView(mission: theseMissions[0]).environmentObject(previewStore)
    } else {
        Text("No missions found in preview store.")
    }
}
