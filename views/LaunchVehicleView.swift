//
//  LaunchVehicleView.swift
//  moonshot
//
//  Created by Adam on 18/05/2026.
//
import SwiftUI

struct LaunchVehicleView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore

    let mission: Mission
    var spacecraft: Spacecraft {
        spaceDataStore.spacecrafts[mission.spacecraft]!
    }

    var launchPhasesV2: [LaunchPhase] {
        if let missionPhases =  mission.launchPhases{
            return missionPhases
        } else {
            return []
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text(spacecraft.spacecraft)
                    Text(spacecraft.spacecraftName).italic()
                }
                Text(mission.displayName)
                if launchPhasesV2.count > 0 {
                    Text(String(launchPhasesV2.count))
                }
                if ["Apollo", "Apollo Applications", "Gemini", "Mercury"].contains(mission.program){
                    ApolloLaunchView(mission: mission)
                }
                else if mission.program == "Space Shuttle"{
                    ShuttleLaunchView(mission: mission)
                }
                else {
                    GenericCapsuleLaunchView(mission: mission)
                }
            }.frame(minHeight: 820)
        }
        .background(.darkBackground)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("Apollo 8")}
    if theseMissions.count > 0 {
        LaunchVehicleView(mission: theseMissions[0]).environmentObject(previewStore)
    } else {
        Text("No missions found in preview store.")
    }
}
