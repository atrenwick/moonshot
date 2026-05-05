//
//  ContentView.swift
//  moonshot
//
//  Created by Adam on 15/04/2026.
//

import SwiftUI

// names wiht 7 are out of kilter as using Mercury Renaming logic 

//MARK: ContentView == Mission ViewList
struct ContentView: View{
    // get astronauts from env object
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var buttonContent: String = "List"
    @State var titleColor: Color = .white
    @State private var layoutMode: LayoutMode = .grid
    @State private var searchText: String = ""

    enum LayoutMode{
        case list
        case listRU
        case grid
    }

//    var allGrouped: Dictionary<String, [Mission]> {
//        Dictionary(grouping: spaceDataStore.missions) {$0.program}
//    }
    
    var body: some View{
        
        NavigationStack{
            Group{
                switch layoutMode {
                case .list:
                    VStack{
                        List{
                            ForEach(spacePrograms, id:\.self){key in
                                Section(header: Text(key)){
                                    ForEach( grouped[key]!.sorted{$0.sortOrder < $1.sortOrder}){mission in
                                        ContentListViewReusableSegment(mission: mission)
                                            .frame(maxHeight: 20)
                                    }
                                }
                            }
                        }.navigationTitle("Missions")
                            .background(.darkBackground)
                            .preferredColorScheme(.dark)
                            .foregroundStyle(.primary)
                        
                    }
                case .listRU:
//                    let printCrewCount = true
                    VStack{
                        List{
                            ForEach(spaceProgramsRU, id:\.self){key in
                                Section(header: Text(key)){
                                    ForEach( grouped[key]!.sorted{$0.sortOrder < $1.sortOrder}){mission in
                                        ContentListViewReusableSegment(mission: mission, printCrewCount: true)
                                            .frame(maxHeight: 20)
                                    }
                                }
                            }
                        }.navigationTitle("Missions")
                            .background(.darkBackground)
                            .preferredColorScheme(.dark)
                            .foregroundStyle(.primary)
                        
                    }
                case .grid:
                    let columns = [GridItem(.adaptive(minimum: 150))]
                    ScrollView{
                        LazyVGrid(columns: columns){
                            ForEach(spacePrograms, id:\.self) {key in
                                Section(header: Text(key)){
                                    ForEach(grouped[key]!.sorted{$0.sortOrder < $1.sortOrder} ){
                                        mission in
                                        MissionCardView(mission: mission)
                                    }
                                    
                                }.padding([.horizontal, .bottom])
                            }
                        }
                    }.navigationTitle("Missions")
                }
            }// navstack
            
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Menu{Button("List") {
                        layoutMode = .list
                        //print("Pressed")
                    }
                        Button("ListRU") {
                            layoutMode = .listRU
                            print("Pressed")
                        }
                        Button("GridUSA") {
                            layoutMode = .grid
                            print("Pressed")
                        }
                    }  label: {
                        Image(systemName: "ellipsis.circle")
                    }
            }
        }
            .background(.darkBackground)
            .preferredColorScheme(.dark)
            .foregroundStyle(.primary)
        }
        // filtering
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .textInputAutocapitalization(.never)
        var grouped: Dictionary<String, [Mission]> {
//            let grouped = allGrouped
            if searchText.isEmpty {return spaceDataStore.groupedMissions}
            else {
//
                let theseMissions = spaceDataStore.missions.filter { mission in mission.name.localizedCaseInsensitiveContains(searchText) }
                if theseMissions.count > 0 {
                    return Dictionary(grouping:theseMissions) {$0.program}
                } else {
                    return spaceDataStore.groupedMissions
                }
                // need to drop program if no results ??
//                 let
//                else { return grouped }
//
                }
            }
        
        
        
        
    } // body
    func toggleLayout() {
        layoutMode = (layoutMode == .list) ? .grid : .list
    }//func
}// view

#Preview {
    ContentView().environmentObject(SpaceDataStore())
}


