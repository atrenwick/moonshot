//
//  AstronautListView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//
//

import SwiftUI
struct AstronautListView: View{
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State private var searchText: String = ""
    @State private var currentScope = SearchScope.name
    @State private var sortType: SortType = .alphabetical
    @State private var sortDisplayText: String = "Duration"
    @State private var genderFilter: GenderFilter?
    @State private var myColor: Color = .green
    @State private var useNumberSort: Bool = false
    @State private var spacewalkMode: String = "alpha"
    
    
    enum SearchScope: String, CaseIterable {
        case name, flights, gender, nationality, duration, spacewalks
    }
    
    enum GenderFilter: String, CaseIterable {
        //« computer, if it is the case that you see M in the raw data, use "this"»
        case M = "Male"
        case F = "Female"
        // the return value here = what appears in View, is sent to $SearchText
        var label: String {
            switch self {
            case.M: return "M"
            case.F: return "F"
            }
        }
    }
    // use closure to get variable == array of dict entries for astronauts, sorted by key
    var allSortedAstronautsArrayAlphabetical: [(key: String, value: Astronaut)] {
        spaceDataStore.astronauts.sorted { $0.key < $1.key }
    }
    // get sorted by decreasing duration of spaceflight
    var allSortedAstronautsArrayDuration: [(key: String, value: Astronaut)] {
        spaceDataStore.astronauts.sorted {
            getDurationFromString($0.value.duration).1
            >
            getDurationFromString($1.value.duration).1
        }
    }
    
    // for-each sees dicts as lists of tuples so convert to array
    var body: some View{
        NavigationStack{
            List{
                // start filter chip
                if currentScope == .gender{
                    ScrollView(.horizontal, showsIndicators: false){
                        // hstack of values to choose:: all, then m-f from for-each
                        HStack(spacing: 8){
                            FilterChipView(title: "All", isSelected: genderFilter == nil){
                                genderFilter = nil
                                searchText = ""
                            }
                            ForEach(GenderFilter.allCases, id:\.self){gender in
                                FilterChipView(title: gender.rawValue,
                                               isSelected: genderFilter == gender)
                                {
                                    genderFilter = gender
                                    searchText = gender.label
                                }
                            }
                        }
                    }.padding(.vertical, 4)
                        .listRowSeparator(.hidden)
                } // end filter chip
                
                ForEach(sortedAstronautsArray, id: \.key) { (key, value) in
                    if let astronautMissions = spaceDataStore.astronautMissionsDict[key] {
                        AstronautListViewRepeatableChunk(sortType: sortType, key: key, value: value, astronautMissions: astronautMissions)
                    }
                }.navigationTitle("Astronauts")
                    .preferredColorScheme(.dark)
            }
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing) {
                    // button, label to show, toggle sort type from A-Z to Duration
                        Button{
                            useNumberSort.toggle()
                        } label: {
                            Text(useNumberSort == true ? "0-9" : "A-Z")
                        }
                    Button {
                        if sortType == .alphabetical {
                            sortDisplayText = "Spacewalks"
                            sortType = .spacewalks
                            myColor = .red
                        } else if sortType == .spacewalks {
                            sortDisplayText = "Duration"
                            sortType =  .duration
                            myColor = .green
                        } else {
                            sortDisplayText = "A-Z"
                            sortType = .alphabetical
                            myColor = .blue
                        } // else
                    } //button
                    label: {
                        Text(sortDisplayText).foregroundStyle(myColor)
                    } // label
                } // tbitem
            }// toolbar
        } // navstack
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .textInputAutocapitalization(.never)
        .searchScopes($currentScope, activation: .onSearchPresentation) {
            ForEach(SearchScope.allCases, id: \.self) { scope in
                Text(scope.rawValue.capitalized)
            } // for each
        } // searchscopes
        
        //MARK: filtering logic
        // this is for filtering searches by name and number of spaceflights
        var sortedAstronautsArray: [(key: String, value: Astronaut)]  {
            
            //MARK: sort type
            var allAstronauts: [(key: String, value: Astronaut)]
            if sortType == .duration {
                if useNumberSort {
                    allAstronauts = allSortedAstronautsArrayDuration
                } else {
                    allAstronauts = allSortedAstronautsArrayAlphabetical
                }

                // alphabetical
            } else if sortType == .alphabetical {
                if useNumberSort{
                    allAstronauts = allSortedAstronautsArrayAlphabetical.sorted {$0.value.spaceflightCount > $1.value.spaceflightCount}
                } else {
                    allAstronauts = allSortedAstronautsArrayAlphabetical
                }
                
            } else {
                // else get spacewalkers
                allAstronauts = allSortedAstronautsArrayAlphabetical.filter { (key,value) in
                    value.spacewalkCount > 0 }
                if useNumberSort {
                    return allAstronauts.sorted {$0.value.spacewalkCount > $1.value.spacewalkCount }
                } else {
                    return allAstronauts.sorted {$0.value.id < $1.value.id }
                }
            }
            if searchText.isEmpty { return allAstronauts }
            
            //MARK: switch view depending on scope
            switch currentScope{
            case .flights:
                guard let count = Int(searchText) else {
                    return allAstronauts
                }
                return allAstronauts.filter {(key,value) in
                    let matchesCount = value.spaceflightCount == count
                    return matchesCount
                }
            case .spacewalks:
                guard let count = Int(searchText) else {return allAstronauts
                }
                allAstronauts = allAstronauts.filter { (key,value) in
                    value.spacewalkCount > 0
                }
                return allAstronauts.filter { (key,value) in
                    let matchesCount = value.spaceflightCount == count
                    return matchesCount
                }
            case .name:
                return allAstronauts.filter { (key,value) in
                    let matchesText = value.name.localizedCaseInsensitiveContains(searchText)
                    return matchesText
                }
            case .duration:
                guard let thisInt = Int(searchText)
                else {return []}
                let thisIntAsDuration: Duration = .seconds(86400.0 * Double(thisInt))
                return allAstronauts.filter { (key,value) in
                    let astronautDurationProper = (getDurationFromString(value.duration).1)
                    let matchesText = astronautDurationProper >= thisIntAsDuration
                    return matchesText
                }
            case .nationality:
                return allAstronauts.filter { (key,value) in
                    let matchesText = value.nationality.localizedCaseInsensitiveContains(searchText)
                    return matchesText
                }
            case .gender:
                return allAstronauts.filter { (key,value) in
                    let matchesText = value.gender == searchText.uppercased()
                    return matchesText
                }
            }
        }
    }
    
}
#Preview{
    AstronautListView().environmentObject(SpaceDataStore())
}
