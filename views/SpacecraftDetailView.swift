//  SpacecraftDetailView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.

import SwiftUI

//TODO: need photos for spacex spacecraft
// for SpaceX, need to add booster numbers to launch
// for apollo, need to add SM, and stack info
// need program overview

//MARK: Spacecraft detail view
struct SpacecraftDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
        
    let spacecraft: Spacecraft
    var spacecraftMissions: [Mission] {
        spaceDataStore.missions.filter { mission in
            mission.spacecraft == spacecraft.spacecraft
        }
    }
    var sortedAstronautsForSpacecraft: ([(key: String, value: Astronaut)],Int, Dictionary<String, Int>)  {
        let spacecraftMissions = spacecraftMissions
        var output: [(key: String, value: Astronaut)]  = []
        var foundNames: [String] = []
        var myDict: Dictionary<String,Int> = [:]
        var myScore:Int = 0
        for mission in spacecraftMissions {
            for crew in mission.crew {
                let key = crew.name
                let value = spaceDataStore.astronauts[crew.name]!
                // add key if missing
                if myDict.keys.contains(key){
                    myDict[key]! += 1
                }
                if myDict.keys.contains(key) == false {
                    myScore += 1
                    myDict[key] = 1
                }
                if foundNames.contains(key) == false {
                    output.append(
                        (key: key, value: value))
                    foundNames.append(key)
                }
            }
        }
        output = output.sorted {$0.key < $1.key}
        let outputTuple = (output, myScore, myDict)
        return outputTuple
    }
    var nameForNavTitle: String {
        spacecraft.spacecraftName +   "  (" + spacecraft.spacecraft + ")"
    }
    // column sizes for mission patches and diff size for astronaut photos
    let columns = [ GridItem(.adaptive(minimum: 150))]
    var body: some View {
        NavigationStack{
            ScrollView{
                if spacecraftMissions.count == 0 {
                    Text(spacecraft.location)
                    Text("Error, no missions found")
                }
                SpacecraftDetailViewHeaderElement(
                    inputCounts: (
                        sortedAstronautsForSpacecraft.0.count,
                        spacecraftMissions.count
                    ),
                    spacecraft: spacecraft
                )

                LazyVGrid(columns: columns){
                    ForEach(spacecraftMissions.sorted{$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}){mission in
                        MissionCardView(mission: mission)
                    } // close filter
                } //close vgrid
                SpacecraftDetailViewAstronautChunk(
                    spacecraft: spacecraft,
                    sortedAstronautsForSpacecraft: sortedAstronautsForSpacecraft
                )
            }.navigationTitle(nameForNavTitle) // scroll
                .background(.darkBackground)
                .preferredColorScheme(.dark)
        } //navstack
    } //viewbody
} //view
//
#Preview {
    SpacecraftDetailView(spacecraft: SpaceDataStore().spacecrafts["SC10"]! ).environmentObject(SpaceDataStore())
}
