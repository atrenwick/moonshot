//
//  MissionListView.swift
//  moonshot
//
//  Created by Adam on 22/04/2026.
//

import SwiftUI
//TODO : need to add an order to missions, then set missionID to be this order, then id can be used in place of x.sorted
//MARK: ContentView == Mission ViewList
struct MissionListView: View {
    let spacePrograms: [String]
    let filteredMissions: [Mission]
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    var hideBackButton: Bool = false
    var grouped: Dictionary<String, [Mission]> {
        Dictionary(grouping: filteredMissions) {$0.program}
    }
    var fullyFilteredMissions: [Mission] {filteredMissions.filter { mission in
        spacePrograms.contains(mission.program) }
    }
    var body: some View{
        NavigationStack{
            List{
                ForEach(fullyFilteredMissions.sorted {$0.sortOrder < $1.sortOrder}) {mission in
                            ContentListViewReusableSegment(mission: mission)
                                .frame(maxHeight: 20)
                        }
            }.navigationTitle("Missions")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
        }.navigationBarBackButtonHidden(hideBackButton)
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let spacePrograms = spaceProgramsUSA
    let filteredMissions = previewStore.missions.filter{ $0.program == "Mercury" }
    MissionListView( spacePrograms: spacePrograms, filteredMissions:filteredMissions).environmentObject(SpaceDataStore())
}
