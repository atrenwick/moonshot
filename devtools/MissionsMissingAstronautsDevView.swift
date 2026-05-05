//
//  MissionsMissingAstronautsDevView.swift
//  moonshot
//
//  Created by Adam on 20/04/2026.
//

import SwiftUI

//MARK: MissionDetailView
struct MissionsMissingAstronautsDevView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
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
    var body: some View{
        NavigationStack{
        let missions = spaceDataStore.missions
        let astronauts = spaceDataStore.astronauts
        var allAstronautList: [String] = spaceDataStore.astronauts.compactMap { (key: String, value: Astronaut) in
            key
        }
        List {
            ForEach(spaceDataStore.missions){ currentMission in
                var thiskey = currentMission.name
                var crewList = currentMission.crew.map{$0.name} + currentMission.backupcrew.map{$0.name}
                ForEach(crewList, id: \.self) { crewMember in
                    if allAstronautList.contains(crewMember) == false {
                        Text("\(thiskey): \(crewMember)")
                        
                    }
                }
                //                missingDict[thiskey] = currentMissionMissing
                
                
            } // close mission
        }.navigationTitle("Astronauts to add") //list
    }//close viewbody
}
        
}// close view
#Preview{
    let previewStore = SpaceDataStore()

    MissionsMissingAstronautsDevView().environmentObject(previewStore)
}



//struct MissionsMissingAstronautsDevView: View {
//
//
//    let mission: Mission
//    let astronauts: [String: Astronaut]
//    // struct to merge data from 2 jsonfiles here
//    var body: some View{
//        ScrollView{
//            VStack {
////                Image(mission.image)
////                    .resizable()
////                    .scaledToFit()
////                    .containerRelativeFrame(.horizontal) {width, axis in
////                        width * 0.6 }
//                VStack(alignment: .leading){
//                    Rectangle()
//                        .frame(height:2)
//                        .foregroundStyle(.lightBackground)
//                        .padding(.vertical)
//                    //                        .padding(.bottom, 5)
//                    VStack{
//                        Text("Mission Highlights").font(.title.bold())
//                            .padding(.bottom, 5)
//                        Text(mission.description)
//                        Rectangle()
//                            .frame(height:2)
//                            .foregroundStyle(.lightBackground)
//                    }
//                    .padding(.horizontal)
//                }
////                let assignments = Assignments(crew: crew, backupcrew: backupcrew)
//                VStack(alignment: .leading){
//                    let upperRange = assignments[1].count > 0 ? 2 : 1
//                    ForEach(0..<upperRange) { x in
//                        Text(x == 0 ? "Crew" : "Backup Crew"
//                        ).font(.title3.bold())
//                            .padding(.bottom, 5)
//                            .padding(.leading, 20)
//                        
//                        ScrollView(.horizontal, showsIndicators: false){
//                            HStack{
//                                ForEach(assignments[x], id: \.id) { crewMember in
//                                    NavigationLink{
//                                        Text("Astronaut details")
//                                        AstronautView(astronaut: crewMember.astronaut)
//                                    } label: {
//                                        VStack(alignment: .leading){
//                                            Image(crewMember.astronaut.id)
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 104, height: 72)
//                                                .clipShape(.capsule)
//                                                .overlay(
//                                                    Capsule()
//                                                        .strokeBorder(.white, lineWidth: 1)
//                                                )
//                                                Text(String(crewMember.astronaut.name[crewMember.astronaut.name.startIndex]) + ". " +  crewMember.astronaut.printSurname)
//                                                    .foregroundStyle(.white)
//                                                    .font(.headline)
//                                                Text(crewMember.role)
//                                                    .foregroundStyle(.secondary)
//                                            
//                                        }.padding(.horizontal)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                        VStack {
//                        Rectangle()
//                            .frame(height:2)
//                            .foregroundStyle(.lightBackground)
//                            .padding(.vertical)
//                        Text("Spacecraft").fontWeight(.semibold)
//                        NavigationLink {
//                            SpacecraftDetailView(spacecraft: spacecraft)
//                        } label: {
//                            
//                            VStack(alignment: .leading) {
//                                Text("\(mission.callsign) (\(mission.spacecraft))")
//                                if spacecraft.location.contains("Lost") == false {
//                                    Text("Currently on display at the \(spacecraft.location)")}
//                                else {
//                                    Text(spacecraft.location)
//                                }
//                            }.foregroundStyle(.white)
//                            
//                        }
//                    }
//                }.padding(.bottom)
//            }
//            .background(.darkBackground)
//            .preferredColorScheme(.dark)
//        }
//    }
//}
//
//#Preview {
//        let previewStore = SpaceDataStore()
//        if let firstMission = previewStore.missions.last {
//            MissionsMissingAstronautsDevView(mission: firstMission, astronauts: previewStore.astronauts)
//                .environmentObject(previewStore)
//            } else {
//                Text("No missions found in preview store.")
//            }
//
//}
