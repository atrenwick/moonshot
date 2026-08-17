//
//  AllGridView.swift
//  moonshot
//
//  Created by Adam on 10/05/2026.
//

import SwiftUI

struct AllGridView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    var filteredMissions: [Mission]
    var body: some View{
        let columns = [GridItem(.adaptive(minimum: 150))]
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach( filteredMissions.sorted{$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}){mission in
                    MissionCardView(mission: mission)
                }//end mission
            }.padding([.horizontal, .bottom])
        }.navigationTitle("Missions") // end scrollview
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .foregroundStyle(.primary)
    }
}


#Preview {
    let previewDataStore = SpaceDataStore()
    let filteredMissions = [previewDataStore.missions[0], previewDataStore.missions[20], previewDataStore.missions[2]]
    AllGridView(filteredMissions: filteredMissions).environmentObject(previewDataStore)
}

