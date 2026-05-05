//
//  AstronautListViewRepeatableChunk.swift
//  moonshot
//
//  Created by Adam on 23/04/2026.
//

import SwiftUI

struct AstronautListViewRepeatableChunk: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let key: String
    let value: Astronaut
    let astronautMissions: [Mission]
    var body: some View {
        NavigationLink{
            AstronautView(astronaut: value)
        } label:
        {   //TODO : just made this lazy : does this solve the OOM crash :: but has spacer issue, doesn't solve OOM crash
            HStack {
                //                Image(systemName: "photo")
                Image("\(value.id)_list")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .frame(minHeight: 1)
                    .clipShape(.circle)
                    .overlay(
                        Circle()
                            .strokeBorder(.white, lineWidth: 1)
                    )
                //                Text(String(spaceDataStore.flightCounts[value.id] ?? 0))
                Text(makeListName(key: key, astronaut: value))
                Spacer()
                
                LazyHStack {
                    ForEach(astronautMissions){mission in

                    if (UIImage(named: mission.image) != nil){
//                        Image(systemName: "photo")
                            Image("\(mission.image)_card")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .frame(minHeight: 1)
                                .clipShape(.circle)
                                .overlay(
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                        } else {
                            
                            let mynum = mission.displayName.replacing(/[^0-9]/, with: "")
                            let calculatedName = "\(mynum).circle.fill"
                            Image(systemName: calculatedName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .frame(minHeight: 1)
                                .clipShape(.circle)
                                .overlay(
                                    Circle()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                        }
                    }
                }
            }
            
            //        }.background(.darkBackground)
            //            .preferredColorScheme(.dark)
        }
    }
}
//
#Preview {
    let thisAstronaut = "leonov"
    let previewDataStore = SpaceDataStore()
    AstronautListViewRepeatableChunk(
//        spaceDataStore: previewDataStore,
        key: thisAstronaut,
        value: previewDataStore.astronauts[thisAstronaut]!,
        astronautMissions: previewDataStore.astronautMissionsDict[thisAstronaut]!
    ).environmentObject(previewDataStore)
}
