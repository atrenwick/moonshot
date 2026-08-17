//
//  LaunchDetailView.swift
//  moonshot
//
//  Created by Adam on 18/05/2026.
//

import SwiftUI

struct LandingDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var endDate: String {
        let output: String = calculateEndDate(
            launchDate: mission.launchDate,
            durationString: mission.duration
        )
        return output
    }

    var spacecraft: Spacecraft {
        spaceDataStore.spacecrafts[mission.spacecraft]!
    }
    
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    Text(spacecraft.spacecraft)
                    Text(spacecraft.spacecraftName).italic()
                }
                
                
                if mission.program == "Space Shuttle" {
                    ShuttleLandingView(mission: mission)
                }
                if ["Apollo", "Apollo Applications", "Skylab","Gemini", "Mercury"].contains(mission.program) {
                    ApolloSplashdownView(mission: mission)
                }
                else {
                    GenericCapsuleLandingView(mission: mission)
                }
            }
        }
        .background(.darkBackground)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("MA-9")}
    if theseMissions.count > 0
    {
        LandingDetailView(mission: theseMissions[0]).environmentObject(previewStore)
    } else {
        Text("No missions found in preview store.")
    }
}

