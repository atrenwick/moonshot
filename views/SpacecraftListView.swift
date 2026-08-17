//
//  SpacecraftListView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//
//MARK: Spacecraft list view
import SwiftUI
struct SpacecraftListView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    
    var grouped: Dictionary<String, [Spacecraft]> {
        Dictionary(grouping: spaceDataStore.spacecrafts.values) {$0.program}
    }
    
    var body: some View{
        NavigationStack{
            List {
                ForEach(spaceProgramsUSA, id: \.self) { key in
                    Section(header: Text(key)) {
                        ForEach( grouped[key]!.sorted {$0.id < $1.id} ) { spacecraft in
                            NavigationLink {
                                SpacecraftDetailView(spacecraft: spacecraft)
                            } label: {
                                HStack{
                                    Text(spacecraft.spacecraft)
                                    Text("\"" + spacecraft.spacecraftName + "\"")
                                    Spacer()
                                    ForEach(spaceDataStore.missions.filter { mission in mission.spacecraft == spacecraft.spacecraft }.prefix(5)){ mission in
                                        Image("\(mission.image)_card")
                                            .resizable()
                                            .scaledToFit()
                                            .applyIf(mission.invertPatch){ content in
                                                content.colorInvert()
                                            }
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
