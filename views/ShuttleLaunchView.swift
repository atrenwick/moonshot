//
//  ShuttleLaunchView.swift
//  moonshot
//
//  Created by Adam on 03/06/2026.
//

import SwiftUI
import MapKit

enum MapTypeSelection: String, CaseIterable, Identifiable {
    case standard = "Map"
    case imagery = "Imagery"
    case hybrid = "Hybrid"
    
    var id: String { self.rawValue }
    
    // Convert our enum selection into the actual MapKit MapStyle structures
    var mapKitStyle: MapStyle {
        switch self {
        case .standard:
            return .standard
        case .imagery:
            return .imagery//(elevation: .realistic)
        case .hybrid:
            // 3. Hybrid maps are called '.hybrid'
            return .hybrid//(elevation: .realistic)
        }
    }
}

struct ShuttleLaunchView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State private var selectedMapType: MapTypeSelection = .imagery
    let mission: Mission

    
    
    var theseLocations: [Location] {
        var outputLocations: [Location] = []
        
        if let launchLocation =  spaceDataStore.launchSites[mission.launchpad]{
            outputLocations.append(launchLocation)
        }
        if let impactLocation = mission.etImpact{
            if let missionTankLocation = mission.makeLocation(
                lat: mission.etImpact?.latitude ?? "0",
                long: mission.etImpact?.longitude ?? "0",
                displayName: mission.displayName,
                type: "ET impact"
            ){
                outputLocations.append(missionTankLocation)
            }
        }
        return outputLocations
    }

    var body: some View {

            let launchLocation = theseLocations[0]
            let targetPosition  = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: launchLocation.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70)
                )
            )
            Map(initialPosition : targetPosition){

                ForEach(theseLocations, id: \.self.id){location in
                    if location.type == "ET impact"{
                        Annotation(location.displayName, coordinate: location.coordinate) {
                                Image(systemName: "fuelpump.fill") // Your special SF Symbol for the target
                                    .font(.title)
                                    .foregroundColor(.green) // Make it stand out from the rest
                                    .background(Circle().fill(.white))
                                    .clipShape(.capsule)
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(.white, lineWidth: 1)
                                    )
                                }
                    } else {
                        Marker(location.displayName, coordinate: location.coordinate)
                    }
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
                        // Blurs the map behind the picker subtly
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.horizontal)
            }
             
            .frame(minHeight: 300)

        List {
            StatsRepeatableElement(item: mission.launchpad, label: "Launchpad")
            StatsRepeatableElement(item: mission.mlpNum, label: "Mobile Launch Platform")
            
            if let azimuthValue =  mission.flightAzimuth{
                StatsRepeatableElement(item: azimuthValue,
                label: "Launch azimuth",
                append: "˚",
                withSeparator: false)
            }

//            StatsRepeatableElement(
//                item: mission.describeOrbit(sMajor: mission.orbitSmaj, sMinor: mission.orbitSmin,
//                    inputUnit: mission.programDefaultLength) ?? "Unknown orbit",
//                label: "Orbit")
//            StatsRepeatableElement(
//                item: mission.orbitalInclination,
//                label: "Orbital Inclination",
//                append: "˚",
//                withSeparator: false)
            StatsRepeatableElement(
                item: mission.launchMass != -1 ? mission.getMeasurementString(thisInt: mission.launchMass, type: .mass, sourceUnit: mission.launchMassUnit ?? mission.programDefaultMass) : "Classified",
                label: "Launch mass")
            StatsRepeatableElement(
                item: mission.cargoTotal != -1 ? mission.getMeasurementString(thisInt: mission.cargoTotal, type: .mass, sourceUnit: mission.cargoTotalUnit ?? mission.programDefaultMass) : "Classified",
                label: "Cargo")
            StatsRepeatableElement(
                item: mission.cargoDeployed != -1 ?
                mission.getMeasurementString(thisInt: mission.cargoDeployed, type: .mass, sourceUnit: mission.cargoDeployedUnit ?? mission.programDefaultMass) : "Classified",
                label: "Cargo deployed")
            StatsRepeatableElement(
                item: mission.cargoReturned != -1 ?
                mission.getMeasurementString(thisInt: mission.cargoReturned, type: .mass, sourceUnit: mission.cargoReturnedUnit ?? mission.programDefaultMass) : "Classified",
                label: "Cargo returned")
            
            if let missionSsmeSet = mission.ssmeSet{
                ForEach(missionSsmeSet, id:\.self.position){ssme in
                    StatsRepeatableElement(
                        item: ssme.num,
                        label: "SSME \(ssme.position)",
                        append: String(ssme.ssmeFlightNum),
                        appendWithBrackets: true)
                }
            }
            StatsRepeatableElement(item: mission.ssmeType, label: "SSME Type")
            StatsRepeatableElement(item: mission.ssmeRatedPower, label: "SSME Rating %")
            StatsRepeatableElement(item: mission.srbSet, label: "SRB Set")
            StatsRepeatableElement(item: mission.rsrmSet, label: "RSRM Set")
            
            // tank
            if let tanktype = mission.tankType{
                if let tankNum = mission.tankNum{
                    HStack{
                        Text("External Tank")
                        Spacer()
                        Text("\(tanktype) -  \(tankNum)")
                    }
                }
            }
            // MARK: manoeuvring
            if let oms1 = mission.oms1{
                if let oms2 = mission.oms2{
                    if let oms3 = mission.oms3{
                        HStack{
                            Text("OMS")
                            Spacer()
                            Text(oms1)
                            Text(oms2)
                            Text(oms3)
                        }
                    }
                }
            }
        }
    }
}
        

#Preview {
    let previewStore = SpaceDataStore()
    let thisString = "STS-1"
    let mission = previewStore.missions.filter {$0.displayName.contains(thisString)}[0]
    ShuttleLaunchView(mission: mission).environmentObject(previewStore)
}
