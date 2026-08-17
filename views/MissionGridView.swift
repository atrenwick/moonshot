//
//  GridView.swift
//  moonshot
//
//  Created by Adam on 10/05/2026.
//

import SwiftUI

struct GridView: View {
    let spacePrograms: [String]
    let filteredMissions: [Mission]
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let columns = [GridItem(.adaptive(minimum: 150))]
    var grouped: Dictionary<String, [Mission]> {
        Dictionary(grouping: filteredMissions) {$0.program}
    }
    var fullyFilteredMissions: [Mission] {filteredMissions.filter { mission in
        spacePrograms.contains(mission.program) }
    }
    var body: some View {
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach(fullyFilteredMissions.sorted {$0.sortOrder < $1.sortOrder}){
                            mission in
                            MissionCardView(mission: mission)
                        }
                    }.padding([.horizontal, .bottom])
        }.navigationTitle("Missions")
    }
}

#Preview {
    let previewDataStore = SpaceDataStore()
    let filteredMissions = [previewDataStore.missions[1],previewDataStore.missions[233], previewDataStore.missions[15]]
    let spacePrograms = spaceProgramsUSA
    GridView(spacePrograms: spacePrograms, filteredMissions:filteredMissions).environmentObject(previewDataStore)
}
