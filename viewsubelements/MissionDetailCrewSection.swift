//
//  MissionDetailCrewSection.swift
//  moonshot
//
//  Created by Adam on 10/05/2026.
//

import SwiftUI
//TODO:function for crew photos, for supportCrew and Capcoms : get photo, and if landscape, get center third as portrait
struct MissionDetailCrewSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    let astronauts: [String: Astronaut]
    
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
            guard let astronaut = astronauts[member.name] else {
                return nil }
            return CrewMember(role: member.role, astronaut: astronaut)
        }
    }
    
    var capcomList: [(key: String, value: Astronaut)] {
        var internalList: [String] = []
        var outputList: [(key: String, value: Astronaut)]  = []
        if let capcomList = mission.capcoms{
            internalList = capcomList
        }
        if internalList.count > 0 {
            for capcomName in internalList {
                if let astronaut = astronauts[capcomName] {
                    outputList.append((key: capcomName, value: astronaut))
                    
                    
                }
            }
        }
        outputList = outputList.sorted {$0.key < $1.key}
        return outputList
    }
    
    var supportCrewList: [(key: String, value: Astronaut)]  {
        var outputList: [(key: String, value: Astronaut)]  = []
        var internalList: [String] = []
        if let supportCrew = mission.supportCrew{
            internalList = supportCrew
        }
        if internalList.count > 0 {
            for sCrewman in internalList{
                if let astronaut = astronauts[sCrewman]{
                    outputList.append((key: sCrewman, value: astronaut))
                }
            }
        }
        outputList = outputList.sorted {$0.key < $1.key}
        return outputList
    }
    
    var body: some View {
        let assignments = [crew, backupcrew]
        let groundAssignments = [supportCrewList, capcomList]
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
                                    Text(crewMember.role.localizedCapitalized)
                                        .foregroundStyle(.secondary)
                                }.padding(.horizontal)
                            }
                        }
                    }
                }
            }
            // ground assignments:
            let thisLimit = Int(2)
            ForEach(0..<thisLimit) { x in
                if groundAssignments[x].count > 0 {
                Text(x == 0 ? "Support Crew" : "Capcoms"
                ).font(.title3.bold())
                    .padding(.bottom, 5)
                    .padding(.leading, 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(groundAssignments[x], id: \.self.key) { (name, astronaut) in
                            NavigationLink{
                                Text("Astronaut details")
                                AstronautView(astronaut: astronaut)
                            } label: {
                                VStack(alignment: .leading){
                                    Image(astronaut.id)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 72, height: 72)
                                        .clipShape(.circle)
                                        .overlay(
                                            Circle()
                                                .strokeBorder(.white, lineWidth: 1)
                                        )
                                    Text(astronaut.printSurname)
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .frame(width: 72)


                                }.padding(.horizontal, 1)
                            }
                        }}
                    }
                }
            }
        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let thisMission = previewStore.missions.filter {$0.displayName.contains("Apollo 8")}
    if thisMission.count > 0 {
        MissionDetailCrewSection(mission: thisMission[0] ,astronauts: previewStore.astronauts).environmentObject(previewStore)
    } else {
        Text("Error")
    }
}
