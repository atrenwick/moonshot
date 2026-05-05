//
//  SpacecraftListView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//

import SwiftUI
    //MARK: Spacecraft list view
struct SpacecraftListView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    
    var grouped: Dictionary<String, [Spacecraft]> {
        Dictionary(grouping: spaceDataStore.spacecrafts.values) {$0.program}
    }
    
    var body: some View{
        NavigationStack{
            List {
                ForEach(spacePrograms, id: \.self) { key in
                    Section(header: Text(key)) {
                        ForEach( grouped[key]!.sorted {$0.id < $1.id} ) { spacecraft in
                            NavigationLink {
                                SpacecraftDetailView(spacecraft: spacecraft)
                            } label: {
                                HStack{
                                    Text(spacecraft.spacecraft)
                                    Text("\"" + spacecraft.spacecraftName + "\"")
                                    Spacer()
                                    // prefix(5) on the filter getss the first x from the filter
                                    ForEach(spaceDataStore.missions.filter { mission in mission.spacecraft == spacecraft.spacecraft }.prefix(5)){ mission in
//                                        Image(systemName: "photo")
                                        Image("\(mission.image)_card")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight: 20)
                                    } //foreach
                                }.frame(maxHeight:20)
                            } //label
                        }
                    }
                }
            }.navigationTitle("Spacecraft")
        }
        .preferredColorScheme(.dark)
    }
}
#Preview{
        SpacecraftListView().environmentObject(SpaceDataStore())

    }
