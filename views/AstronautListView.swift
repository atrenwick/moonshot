//
//  AstronautListView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//
//
//

import SwiftUI
//
struct AstronautListView: View{
        @EnvironmentObject var spaceDataStore: SpaceDataStore
        @State private var searchText: String = ""
        @State private var currentScope = SearchScope.name

    // need to add option to search my number of flights, or mission :: similar logic to lexicoscopeFront
    enum SearchScope: String, CaseIterable {// need to tweak these for astronaut name, mission name, astronaut flight count
        case name, flights
    }
    // use closure to get variable which is an array of dict entries for astronauts, sorted by key
        var allSortedAstronautsArray: [(key: String, value: Astronaut)] {
            spaceDataStore.astronauts.sorted { $0.key < $1.key }
        }
        // for-each sees dicts as lists of tuples cf proper dicts, thus convert to array to deal with them easily
        var body: some View{
            NavigationStack{
                List{
                    ForEach(sortedAstronautsArray, id: \.key) { (key, value) in
                        if let astronautMissions = spaceDataStore.astronautMissionsDict[key] {
                            AstronautListViewRepeatableChunk(key: key, value: value, astronautMissions: astronautMissions)
                        }
                    }.navigationTitle("Astronauts")
                        .preferredColorScheme(.dark)
                }
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
            .textInputAutocapitalization(.never)
            .searchScopes($currentScope, activation: .onSearchPresentation) {
                ForEach(SearchScope.allCases, id: \.self) { scope in
                    Text(scope.rawValue.capitalized)
                }
            }

            // this is for filtering searches by name and number of spaceflights
            var sortedAstronautsArray: [(key: String, value: Astronaut)]  {
                let allAstronauts = allSortedAstronautsArray
                if searchText.isEmpty { return allAstronauts }
                
                switch currentScope{
                    case .flights:
                    guard let count = Int(searchText) else {
                        return allAstronauts
                    }
                    return allAstronauts.filter {(key,value) in
                        let matchesCount = spaceDataStore.flightCounts[value.id] ?? 0 == count
                        return matchesCount
                    }
                case .name:
                    return allAstronauts.filter { (key,value) in
                        let matchesText = value.name.localizedCaseInsensitiveContains(searchText)
                        return matchesText
                    }
                }
            }
        }
    func flightCount(for astronaut: Astronaut) -> Int {
        spaceDataStore.flightCounts[astronaut.id] ?? 0
    }
}
#Preview{
    AstronautListView().environmentObject(SpaceDataStore())

}
