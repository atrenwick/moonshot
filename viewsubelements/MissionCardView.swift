//
//  MissionCardView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//

import SwiftUI

struct MissionCardView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var endDate: String {
        let output: String = calculateEndDate(
            launchDate: mission.launchDate,
            durationString: mission.duration
        )
        return output
    }
    
    
    var showEndDate: Bool {
         endDate != mission.formattedLaunchDate ? true : false
        }
//    
    var body: some View {
            NavigationLink{
                MissionView(mission: mission, astronauts: spaceDataStore.astronauts)
            } label: {
                VStack{
//                    Image(systemName: "photo")
                    Image("\(mission.image)_card")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    
                    VStack{
                        Text(mission.displayName).font(.headline).foregroundStyle(.white)
                        HStack{
                            Text(mission.formattedLaunchDate)
                            
                            if showEndDate {
                                Text(" - ")
                                Text(endDate)
                            }
                        }.font(.caption).foregroundStyle(.gray)
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(.lightBackground)
                }
                .clipShape(.rect(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10) // add rounded corners to cards
                        .stroke(.lightBackground)
                )
            }
        }
    }
        
    
    
#Preview{
    let mission = SpaceDataStore().missions.last
    MissionCardView(mission: mission!).environmentObject(SpaceDataStore())
}

