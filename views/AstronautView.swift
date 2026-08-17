//
//  AstronautView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//

import SwiftUI
//MARK: AstronautView
struct AstronautView: View {

    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var backupShowMessageElement = "Show"
    @State var showingBackupAssignments =  false
    let astronaut: Astronaut
    
    var astronautMissions: [Mission] { spaceDataStore.missions.filter { mission in
        mission.crew.contains { crewMember in
            crewMember.name == astronaut.id
                }
            }
        }

    var astronautExpeditions: [Expedition] { spaceDataStore.expeditions.values.filter { expedition in
        expedition.astronauts.contains(astronaut.id)
            }
        }

    var astronautSpacewalks: [Spacewalk] {
        let unsortedSpacewalks = spaceDataStore.spacewalks.values.filter { item in
        item.spacewalkers.contains { spacewalkerName in
            spacewalkerName.name == astronaut.id
            }
        }
        return unsortedSpacewalks.sorted {$0.number < $1.number}
    }
    
    var spacecraftForAstronaut: [String] {
            var theseSpacecraft: [String] = []
            for mission in astronautMissions {
                if theseSpacecraft.contains(mission.spacecraft) == false {
                    theseSpacecraft.append(mission.spacecraft)
                }
            }
            return theseSpacecraft
        }

    var astronautBackupMissions: [Mission] { spaceDataStore.missions.filter { mission in
        mission.backupcrew.contains { crewMember in
            crewMember.name == astronaut.id
                }
            }
        }

    var astronautCapcom: [Mission] {
        var theseMissions: [Mission] = []
        for mission in spaceDataStore.missions{
            if let theseCapcoms = mission.capcoms{
                if theseCapcoms.contains(astronaut.id){
                    theseMissions.append(mission)
                }
            }
        }
        return theseMissions
    }
    
    var astronautSupportAssignments: [Mission] {
        var theseAssignments: [Mission] = []
        for mission in spaceDataStore.missions{
            if let supportCrew = mission.supportCrew{
                if supportCrew.contains(astronaut.id){
                    theseAssignments.append(mission)
                }
            }
        }
        return theseAssignments
    }
    
    var astronautFlightTime: String {
        var myFlightTime: Duration = Duration.zero
        for mission in astronautMissions{
            myFlightTime += getMissionAsDuration(mission.duration)
        }
        let returnString = myFlightTime.formatted(.units(allowed: [.days, .hours, .minutes, .seconds]))
        return returnString
    }
    
    var astronautSpaceflightCount: Int {
        astronautMissions.count
    }
    
    var body: some View {

        ScrollView{
            VStack{
                VStack{
                    //                    Image(systemName: "photo")
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                    if let flagImage = countryToFlag[astronaut.nationality] {
                        Text(flagImage)
                    } else {
                        Text(astronaut.nationality)
                    }
                    let url1 = astronaut.urlSpacefacts ?? "error"
                    if url1 != "error" {
                        LinkView(buttonText: "Spacefacts.de Page", targetURL: url1)
                    }
                    let url2 = astronaut.urlWikipedia ?? "error"
                    if url2 != "error" {
                        LinkView(buttonText: "Wikipedia Page", targetURL: url2)
                    }
                    Text(astronaut.group)
                    let inflectedSpaceflight = astronautSpaceflightCount == 1 ? " spaceflight" : " spaceflights"
                    let spaceflightText = String(astronautMissions.count) + inflectedSpaceflight
                    Text(spaceflightText)
                    let inflectedSpacewalks = astronautSpacewalks.count == 1 ? " spacewalk" : " spacewalks"
                    let spacewalkText = String(astronautSpacewalks.count) + inflectedSpacewalks
                    Text(spacewalkText)
                    
                    if astronaut.duration != "0" {
                        Text(getDurationFromString(astronaut.duration).0)
                    }
                    
                    Text(astronaut.description)
                        .padding(.horizontal)
                }
                .containerRelativeFrame(.horizontal) {width, axis in
                    width * 1.0 }
                //MARK: missions section
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
                Text("Missions").fontWeight(.semibold)
                ScrollView(.horizontal){
                    HStack{
                        ForEach(astronautMissions.sorted {$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}) {mission in
                            AstronautDetailViewMissionsSection(mission: mission)
                        }
                    }
                }.frame(maxWidth: .infinity)
            }
            // MARK: spacewalk section
            if astronautSpacewalks.count > 0 {
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
                Text("\(astronautSpacewalks.count) spacewalks")

                VStack{
                    ScrollView(.horizontal){
                    HStack{
                        ForEach(Array(astronautSpacewalks.enumerated()), id:\.offset){ num,spacewalk in
                            VStack{
                                SpacewalkRepeatableView(
                                    missionName: spacewalk.mission,
                                    spacewalk: spacewalk,
                                    num: num,
                                    showSpacewalkerName: false,
                                    showEVAname: false)
                                Text("EVA \(spacewalk.number)")
                            }
                        }
                    }
                }
                }
            }
            // MARK: spacecraft section
            if spacecraftForAstronaut.count > 0 {
                VStack{
                    Rectangle()
                        .frame(height:2)
                        .foregroundStyle(.lightBackground)
                    Text("Spacecraft").fontWeight(.semibold)
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(0..<spacecraftForAstronaut.count){num in
                                AstronautDetailViewSpacecraftSection(spacecraftForAstronaut: spacecraftForAstronaut, num: num)
                            }
                        }
                    }
                }
            }

            // MARK:  backup missions segment :: close, but still need to remove button when only backup missions
            //TODO: add indexlist to R of astronauts
            if astronautBackupMissions.count > 0{
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
            var backupShowMessageElement = showingBackupAssignments ? "Hide" : "Show"
            Button("\(backupShowMessageElement) other assignments"){
                showingBackupAssignments.toggle()
                backupShowMessageElement = showingBackupAssignments ? "Hide" : "Show"
                }
            }
            if showingBackupAssignments {
                VStack{
                    Text("Backup crew assignments").fontWeight(.semibold)
                    ScrollView(.horizontal){
                            HStack{
                                ForEach(astronautBackupMissions.sorted {$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}) {mission in
                                    VStack{
                                    AstronautDetailViewMissionsSection(mission: mission)
                                    let targetCrewMember =  mission.backupcrew.filter {crewMember in crewMember.name == astronaut.id}
                                    Text(targetCrewMember.first?.role ?? "x")
                                }
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }
                if astronautSupportAssignments.count > 0 {
                    VStack{
                        Text("Support crew assignments").fontWeight(.semibold)
                        ScrollView(.horizontal){
                                HStack{
                                    ForEach(astronautSupportAssignments.sorted {$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}) {mission in
                                        VStack{
                                        AstronautDetailViewMissionsSection(mission: mission)
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }
                }
                if astronautCapcom.count > 0 {
                    VStack{
                        Text("CAPCOM duties").fontWeight(.semibold)
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(astronautCapcom.sorted {$0.launchDate ?? .distantPast < $1.launchDate ?? .distantPast}) {mission in
                                    VStack{
                                        AstronautDetailViewMissionsSection(mission: mission)
                                    }
                                }
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    
                }
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        }
    }

#Preview {
    let spaceDataStore = SpaceDataStore()
    let astronautName: String = "bowen"
    if let foundAstronaut = spaceDataStore.astronauts[astronautName] {
        AstronautView(astronaut: foundAstronaut).environmentObject(SpaceDataStore())
    } else
        {
            Text("Not found")
        }
}

/*
 NavigationStack {
     Text("Hello, World!").padding()
         .navigationTitle("SwiftUI")
         .toolbar {
             ToolbarItemGroup(placement: .bottomBar) {
                 Button("First") {
                     print("Pressed")
                 }

                 Spacer()

                 Button("Second") {
                     print("Pressed")
                 }
             }
         }
 }

 */
