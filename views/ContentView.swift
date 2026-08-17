//
//  ContentView.swift
//  moonshot
//
//  Created by Adam on 15/04/2026.
//
import SwiftUI

//MARK: ContentView == Mission ViewList/grid
struct ContentView: View{
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var buttonContent: String = "List"
    @State var titleColor: Color = .white
    @State private var layoutMode: LayoutMode = .grid
    @State private var spaceProgramSelection: SpaceProgramSelection = .USA
    @State private var searchText: String = ""
    @State private var spacePrograms: [String] = spaceProgramsUSA // + spaceProgramsRU + ["Shenzhou"]
    enum SpaceProgramSelection{
        case RUS
        case USA
        case CNA
        case all
    }
    
    enum LayoutMode{
        case list
        case grid
        case allList
        case allGrid
    }
    
    var body: some View{
        
        NavigationStack{
            Group{
                switch layoutMode {
                case .list:
                    MissionListView(spacePrograms: spacePrograms, filteredMissions: filteredMissions)

                case .allGrid:
                    AllGridView(filteredMissions: filteredMissions)

                case .allList:
                    AllListView(filteredMissions: filteredMissions)

                case .grid:
                    GridView(spacePrograms: spacePrograms, filteredMissions: filteredMissions)
                }// end switch
            }// navstack
            .navigationTitle("Missions")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .foregroundStyle(.primary)

            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu{
                        Button("USA") {
                            spaceProgramSelection = .USA
                            spacePrograms = spaceProgramsUSA
                        }
                        Button("RUS") {
                            spaceProgramSelection = .RUS
                            spacePrograms = spaceProgramsRU
                    }
                        Button("CNA") {
                            spaceProgramSelection = .CNA
                            spacePrograms = ["Shenzhou"]
                            
                    }
                        Button("All") {
                            spaceProgramSelection = .all
                            spacePrograms = spaceProgramsUSA + spaceProgramsRU + ["Shenzhou"]
                            if layoutMode == .grid {
                                layoutMode = .allGrid
                            } else if layoutMode == .list {
                                layoutMode = .allList
                            }
                        }
                    }  label: {
                        Image(systemName: "flag")
                    }
            }
                //MARK: toolbar item for list/grid toggle
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        if layoutMode == .grid { layoutMode = .list}
                        else if layoutMode == .allGrid  { layoutMode = .allList}
                        else if layoutMode == .list {  layoutMode = .grid}
                        else if layoutMode == .allList {
                            layoutMode = .allGrid}
                        else {layoutMode = layoutMode}
                    } label: {
                        Text((layoutMode == .grid  || layoutMode == .allGrid ) ? "List" : "Grid")
                    }
                }
            }
        }
        // filtering
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .textInputAutocapitalization(.never)

        var filteredMissions: [Mission] {
            if searchText.isEmpty {return spaceDataStore.missions}
            // if in all_mode : ignore programs
            else if layoutMode == .allList || layoutMode == .allGrid {
                let theseMissions = spaceDataStore.missions.filter { mission in mission.name.localizedCaseInsensitiveContains(searchText) }
                if theseMissions.count > 0 {
                    return theseMissions
                    //return Dictionary(grouping:theseMissions) {$0.program}
                } else {
                    return []
                }
            }
            else if spaceProgramSelection == .RUS {
                // get missions  filtered and grouped by program
                let theseMissions = spaceDataStore.missions.filter { mission in mission.name.localizedCaseInsensitiveContains(searchText) && spaceProgramsRU.contains(mission.program)}
                if theseMissions.count > 0 {
                    return theseMissions
                } else {
                    return [spaceDataStore.missions[0]]
                }
            } else if spaceProgramSelection == .USA{
                // get missions filtered and grouped by program
                let theseMissions = spaceDataStore.missions.filter { mission in mission.name.localizedCaseInsensitiveContains(searchText) && spaceProgramsUSA.contains(mission.program)}
                return theseMissions
            } else if spaceProgramSelection == .CNA{

                let theseMissions = spaceDataStore.missions.filter { mission in mission.name.localizedCaseInsensitiveContains(searchText) && mission.program == "Shenzhou" }
                return theseMissions
            } else {
                return [spaceDataStore.missions[0]]
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


