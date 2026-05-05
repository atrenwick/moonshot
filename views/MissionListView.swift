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
    
    // get astronauts from env object
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    var hideBackButton: Bool = false
    //TODO: to move ????
    var grouped: Dictionary<String, [Mission]> {
        Dictionary(grouping: spaceDataStore.missions) {$0.program}
    }
    
    var body: some View{
        NavigationStack{
            List{
                ForEach(spacePrograms, id:\.self){key in
                    Section(header: Text(key)){
                        ForEach( grouped[key]!.sorted{$0.sortOrder < $1.sortOrder}){mission in
                            ContentListViewReusableSegment(mission: mission)
                                .frame(maxHeight: 20)
                        }
                    }
                }
            }.navigationTitle("Moonshot")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing){
                        NavigationLink("Grid") {
                            ContentView()
                    }
                }
            }
        }.navigationBarBackButtonHidden(hideBackButton)
    }
}


#Preview {
    MissionListView().environmentObject(SpaceDataStore())
}
