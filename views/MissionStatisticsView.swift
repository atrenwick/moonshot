//
//  MissionStatisticsView.swift
//  moonshot
//
//  Created by Adam on 18/05/2026.
//

import SwiftUI

struct MissionStatisticsView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var spacecraft: Spacecraft {
        spaceDataStore.spacecrafts[mission.spacecraft]!
    }
    var vehicleTotalFlightCount: Int {
        spaceDataStore.missions.filter {$0.spacecraft == spacecraft.spacecraft}.count
    }
    
    
    var body: some View {
        NavigationStack{
            Section{
                List{
                    StatsRepeatableElement(item: mission.hsftag, label: "HSF tag")
                    StatsRepeatableElement(item: mission.cosparDesig, label: "COSPAR designation")
                    StatsRepeatableElement(item: mission.jtag, label: "JTAG")
                    StatsRepeatableElement(item: mission.hsfid, label: "HSFID designation")
                    if let humanOrbFlightNum = mission.humanOrbFlightNum{
                        HStack{
                            Text("Human orbital spaceflight")
                            Spacer()
                            Text("\(humanOrbFlightNum.replacing("ORB", with:""))")
                        }
                    }
                    StatsRepeatableElement(item: mission.countryOrb, label: "\(spacecraft.country) orbital mission")
                    StatsRepeatableElement(item: mission.programFlightSeq, label: "\(mission.program) program flight")
                    StatsRepeatableElement(item: mission.ssf, label: "Manned spacestation flight")
                    StatsRepeatableElement(item: mission.orbits, label: "Orbits")
                    StatsRepeatableElement(item: mission.distance, label: "Distance (million miles)")
                    StatsRepeatableElement(item: mission.orbitSmaj, label: "Semi-major axis")
                    StatsRepeatableElement(item: mission.orbitSmin, label: "Semi-minor axis")
                    if let vehicleFlightCount = mission.vehicleFlightCount{
                        HStack{
                            
                            if mission.program == "Space Shuttle"{
                                Text("Flight of \(spacecraft.spacecraftName) (of \(vehicleTotalFlightCount)")
                            } else {
                                Text("Flight of \(mission.spacecraft)")
                            }
                            Spacer()
                            Text(String(vehicleFlightCount))
                        }
                    }
                    if let _ = mission.records {
                        StatsRepeatableElement(item: mission.records, label: "Records")
                    }
                }.navigationTitle(mission.displayName)
                    .background(.darkBackground)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("Apollo 8")}
    if theseMissions.count > 0
    {
        MissionStatisticsView(mission: theseMissions[0]).environmentObject(previewStore)
    }
}
