//
//  MissionSpacewalkSectionView.swift
//  moonshot
//
//  Created by Adam on 22/05/2026.
//

import SwiftUI

struct MissionSpacewalkSectionView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    
    let mission: Mission
    let exclusionlist: [String] = ["Isaacman","Gilles"]
    var theseSpacewalkers: [String] {
        var foundNames: [String] = []
        if let theseEVAS =  mission.missionEVAS{
            for thisEVA in theseEVAS {
                let evaData = spaceDataStore.spacewalks[thisEVA]!
                for spacewalker in evaData.spacewalkers {
                    let spacewalkerName = spacewalker.name
                    if exclusionlist.contains(spacewalkerName) == false {
                        if foundNames.contains(spacewalkerName) == false {
                            foundNames.append(spacewalkerName)
                        }
                    }
                }
            }
        }
        return foundNames.sorted {$0 < $1}
    }
    
    var body: some View {
        
        if let theseEVAS = mission.missionEVAS {
            if theseEVAS.count > 0{
                VStack{
                    Rectangle()
                        .frame(height:2)
                        .foregroundStyle(.lightBackground)
                    VStack(alignment: .leading){
                        ScrollView{
                            // show the view
                            Text("\(theseEVAS.count) EVAs")                .font(.title3.bold())
                                .foregroundStyle(.primary)
                                .padding(.bottom, 5)
                                .padding(.leading, 20)
                        }
                        HStack{
                            ForEach(theseSpacewalkers, id:\.self){spacewalkerName in
                                let thisAstronaut: Astronaut = spaceDataStore.astronauts[spacewalkerName]!
                                NavigationLink{
                                    Text("EVAs details")
                                    SpacewalkDetailView(mission: mission)
                                } label: {
                                    
                                    VStack{
                                        Image(thisAstronaut.id)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 104, height: 72)
                                            .clipShape(.capsule)
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(.white, lineWidth: 1)
                                            )
                                        Text(thisAstronaut.printSurname)
                                            .font(.headline)
                                            .foregroundStyle(.primary)
                                    }.padding(.horizontal) //innermost vstack
                                    Spacer()
                                }  // foreach
                            }
                        } // hstack
                    } //inner vstack
                    .background(.darkBackground)
                    .preferredColorScheme(.dark)
                }  //outer vstack
            } // if
        } // iflet
    } // body
}  //view

#Preview {
    let previewStore = SpaceDataStore()
    let filteredMissions = previewStore.missions.filter{ $0.name.contains("134")}
    MissionSpacewalkSectionView(mission: filteredMissions.first!).environmentObject(previewStore)
}
