//
//  GenericCapsuleLandingView.swift
//  moonshot
//
//  Created by Adam on 08/06/2026.
//

import SwiftUI

struct GenericCapsuleLandingView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
	let landingType = "Landing"
    var endDate: String {
        let output: String = calculateEndDate(
            launchDate: mission.launchDate,
            durationString: mission.duration
        )
        return output
    }

    var body: some View {
        OptionalMissionLocationView<Any>( locationType: "landing", location: spaceDataStore.landingSites[mission.landingSite ?? "x"],
                                          mission: mission)

        
            List{
                StatsRepeatableElement(item: endDate, label: "Landing date")
                
                if let lmass = mission.getMeasurementString(thisInt: mission.landingMass, type: .mass, sourceUnit: mission.landingMassUnit ?? "kg"){
                    StatsRepeatableElement(
                        item: lmass,
                        label: "Landing mass"
                    )
                }

                
                
            }.frame(minHeight: 180)
        }


}


#Preview {
    let previewStore = SpaceDataStore()
    let thisValue = "Soyuz MS-20"
    let thisMission: [Mission] = previewStore.missions.filter {mission in
        mission.displayName.contains(thisValue)}
    if thisMission.count > 0
    { GenericCapsuleLandingView(mission: thisMission[0]).environmentObject(previewStore)
    } else {
        Text("error")
    }
}
