//
//  ShuttleLandingView.swift
//  moonshot
//
//  Created by Adam on 02/06/2026.
//

import SwiftUI

struct ShuttleLandingView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission

    var body: some View {
        
        List{
            if let eomm = mission.getMeasurementString(thisInt: mission.eomMass, type: .mass, sourceUnit: mission.eomMassUnit ?? "lb"){
                StatsRepeatableElement(
                    item: eomm,
                    label: "End of mission mass"
                )
            }
            if let lmass = mission.getMeasurementString(thisInt: mission.landingMass, type: .mass, sourceUnit: mission.landingMassUnit ?? "lb"){
                StatsRepeatableElement(
                    item: lmass,
                    label: "Landing mass"
                )
            }
            StatsRepeatableElement(
                item: spaceDataStore.landingSites[mission.landingSite ?? "UNK"]!.displayName,
                label: "Landing Site",
                useUpper: mission.landingSite == "kslf" ? true : false)
            
            StatsRepeatableElement(
                item: mission.runway,
                label: "Runway"
            )
            if let d1 = mission.getMeasurementString(thisInt: mission.wheelstopDistance, type: .length, sourceUnit: mission.wheelstopDistanceUnit ?? "ft"){
                StatsRepeatableElement(
                    item: d1,
                    label: "Wheelstop distance"
                )
            }
            
            if let d2 = mission.getMeasurementString(thisInt: mission.rolloutDistance, type: .length, sourceUnit: mission.rolloutDistanceUnit ?? "ft"){
                StatsRepeatableElement(
                    item: d2,
                    label: "Rollout distance"
                )
            }
        }.frame(minHeight: 380)

        
    }
}

#Preview {
    
    let previewStore = SpaceDataStore()
    let thisValue = "STS-1"
    let thisMission: [Mission] = previewStore.missions.filter {mission in
        mission.displayName.contains(thisValue)}
    if thisMission.count > 0
    { ShuttleLandingView(mission: thisMission[0]).environmentObject(previewStore)
    } else {
        Text("error")
    }
}
