//
//  RUContentView.swift
//  moonshot
//
//  Created by Adam on 04/05/2026.
//

import SwiftUI
// dev version before integration itno ContentView
struct AllListView: View{
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    var filteredMissions: [Mission]
    
    var body: some View{
        VStack{
            List{
                ForEach( filteredMissions.sorted{$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}){mission in
                    ContentListViewReusableSegment(mission: mission, printCrewCount: false)
                        .frame(maxHeight: 20)
                }//end mission
            }.navigationTitle("Missions") // end list
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .foregroundStyle(.primary)
        }//end vstack
    }
}

#Preview {
    let previewDataStore = SpaceDataStore()
    let filteredMissions = [previewDataStore.missions[13], previewDataStore.missions[133], previewDataStore.missions[213]]
    AllListView(filteredMissions:filteredMissions).environmentObject(previewDataStore)
}
