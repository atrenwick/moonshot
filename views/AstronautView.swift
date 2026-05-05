//
//  AstronautView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//

import SwiftUI
// need astronaut bios data
// TODO: // need to add show/hide button to allow manual control
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
    
    var astronautFlightTime: String {
        var myFlightTime: Duration = Duration.zero
        for mission in astronautMissions{
            myFlightTime += getMissionAsDuration(mission.duration)
        }
        let returnString = myFlightTime.formatted(.units(allowed: [.days, .hours, .minutes, .seconds]))
        return returnString
    }
    
    var body: some View {

        ScrollView{
            VStack{
                VStack{
//                    Image(systemName: "photo")
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                    Text(astronaut.group)
                    Text("\(astronautMissions.count) spaceflights")
                    Text("\(astronautFlightTime) flighttime")

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
            // MARK: spacecraft section
            if spacecraftForAstronaut.count > 0
            {
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
            //TODO: add indexlist to rigth of astronauts
            if astronautBackupMissions.count > 0{
                
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
            var backupShowMessageElement = showingBackupAssignments ? "Hide" : "Show"
            Button("\(backupShowMessageElement) backup assignments"){
                showingBackupAssignments.toggle()
                backupShowMessageElement = showingBackupAssignments ? "Hide" : "Show"
                
            }}
            if showingBackupAssignments {
                VStack{
                    Text("Backup assignments").fontWeight(.semibold)
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
        AstronautView(astronaut: spaceDataStore.astronauts["kellys"]!).environmentObject(SpaceDataStore())
    }

