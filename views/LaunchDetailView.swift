//
//  LaunchDetailView.swift
//  moonshot
//
//  Created by Adam on 18/05/2026.
//

import SwiftUI

struct LaunchDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission

    var body: some View {
        List{
//            if mission.program == "Space Shuttle"{
            StatsRepeatableElement(
                item: mission.getFormattedDate(inputDate: mission.launchDate),
                label: "Date"
            )
            StatsRepeatableElement(
                item: mission.launchpad,
                label: "Launchpad"
            )
            if let thisMLP = mission.mlpNum {
            StatsRepeatableElement(item: thisMLP, label: "Launch Platform number")
            }
        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("oyuz")}
    if theseMissions.count > 0 {
        LaunchDetailView(mission: theseMissions[0]).environmentObject(previewStore)
    } else {
        Text("No missions found in preview store.")
    }
}
