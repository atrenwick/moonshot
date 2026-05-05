//
//  MissionDetailView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//

//TODO : get mission descriptions for all missing
// display landing date
import SwiftUI
import MapKit
//MARK: MissionDetailView
struct MissionView: View {
    
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let launchLocation = Location(displayName:"KSC LC39A", coordinate: CLLocationCoordinate2D(latitude: 28.608333, longitude: -80.604444), type: "reported")
    let defaultLaunchLocation = Location(displayName:"Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), type: "reported")
    
    let mission: Mission
    let astronauts: [String: Astronaut]
    // struct to merge data from 2 jsonfiles here
    struct CrewMember: Identifiable {
        let id = UUID()
        let role: String
        let astronaut: Astronaut
    }
    struct Assignments: Identifiable {
        let id = UUID()
        let crew: [CrewMember]
        let backupcrew: [CrewMember]
    }
    var spacecraft: Spacecraft {
        spaceDataStore.spacecrafts[mission.spacecraft]!
    }

    var crew: [CrewMember] {
        mission.crew.compactMap { member in
            // 1. Try to find the astronaut
            guard let astronaut = astronauts[member.name] else {
                return nil // 2. If not found, return nil (compactMap skips this)
            }
            // 3. Return the fully formed object
            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
    
    var backupcrew: [CrewMember] {
        mission.backupcrew.compactMap { member in
            // 1. Try to find the astronaut
            guard let astronaut = astronauts[member.name] else {
                return nil // 2. If not found, return nil (compactMap skips this)
            }
            // 3. Return the fully formed object
            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
    
    var body: some View{
        let assignments = [crew, backupcrew]
        ScrollView{
            //MARK: mission patch section
            VStack {
//                Image(systemName: "photo")
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) {width, axis in
                        width * 0.6 }
                VStack(alignment: .leading){
                    Rectangle()
                        .frame(height:2)
                        .foregroundStyle(.lightBackground)
                        .padding(.vertical)
                    //
                    VStack{
                        Text("Overview").font(.title.bold())
                        HStack{
                            Text("Launch: \(mission.formattedLaunchDate)")
                            Text(mission.launchpad)}
                        HStack{
                            Text("Landing")
                            Text(mission.landingSite ?? "nil")}
                        Text("Distance")
                        Text("Time : \(mission.duration)")
                    }

                    VStack{
                        Text("Mission Summary").font(.title.bold())
                            .padding(.bottom, 5)
                        Text(mission.description)
                        Rectangle()
                            .frame(height:2)
                            .foregroundStyle(.lightBackground)
                    }
                    .padding(.horizontal)
                }
            }
            //MARK: crew segment
            VStack(alignment: .leading){
                let upperRange = assignments[1].count > 0 ? 2 : 1
                ForEach(0..<upperRange) { x in
                    Text(x == 0 ? "Crew" : "Backup Crew"
                    ).font(.title3.bold())
                        .padding(.bottom, 5)
                        .padding(.leading, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(assignments[x], id: \.id) { crewMember in
                                NavigationLink{
                                    Text("Astronaut details")
                                    AstronautView(astronaut: crewMember.astronaut)
                                } label: {
                                    VStack(alignment: .leading){
//                                        Image(systemName: "photo")
                                        Image(crewMember.astronaut.id)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 104, height: 72)
                                            .clipShape(.capsule)
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(.white, lineWidth: 1)
                                            )
                                        Text(String(crewMember.astronaut.name[crewMember.astronaut.name.startIndex]) + ". " +  crewMember.astronaut.printSurname)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                        Text(crewMember.role)
                                            .foregroundStyle(.secondary)
                                    }.padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            //MARK: Spacecraft picture
            VStack {
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
                    .padding(.vertical)
                Text("Spacecraft").fontWeight(.semibold)
                NavigationLink {
                    SpacecraftDetailView(spacecraft: spacecraft)
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(mission.callsign) (\(mission.spacecraft))")
                        if spacecraft.location.contains("Lost") == false {
                            Text("Currently on display at the \(spacecraft.location)")
//                            Image(systemName: "photo")
                            Image(spacecraft.spacecraft)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth: 400)
                        }
                        else {
                            Text(spacecraft.location)
                        }
                    }.foregroundStyle(.white)
                }
            }
            //MARK: subsidiaryspacecraft if any
            if mission.hasSubsidiarySpaceCraft {
                let subspacecraft = spaceDataStore.subsidiarySpaceCrafts[mission.name]!
                
                VStack{
                    Text("Lunar Module")
                    Text(subspacecraft.spacecraft)
                    Text(subspacecraft.spacecraftName)
                    Text(subspacecraft.type)
                }
                
            }
            
        //MARK: Mission locations ::
            OptionalMissionLocationView<Any>( locationType: "launch", location: spaceDataStore.launchSites[mission.launchpad])
            OptionalMissionLocationView<Any>( locationType: "landing", location: spaceDataStore.landingSites[mission.landingSite ?? "x"])


    }.padding(.bottom) // scrollview
    .background(.darkBackground)
    .preferredColorScheme(.dark)
        } // body
    }// view




#Preview {
        let previewStore = SpaceDataStore()
        if let firstMission = previewStore.missions.first {
                    MissionView(mission: firstMission, astronauts: previewStore.astronauts)
                .environmentObject(previewStore)
            } else {
                Text("No missions found in preview store.")
            }

}

