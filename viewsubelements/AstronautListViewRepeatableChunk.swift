//
//  AstronautListViewRepeatableChunk.swift
//  moonshot
//
//  Created by Adam on 23/04/2026.
//

import SwiftUI

struct AstronautListViewRepeatableChunk: View {


    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let sortType: SortType
    let key: String
    let value: Astronaut
    let astronautMissions: [Mission]
    
    var badgeMissions: [Mission] {
        astronautMissions.filter { mission in
            mission.crew.contains {crewMember in
                crewMember.name == value.id
            }
        }
    }
    
    var body: some View {
        NavigationLink{
            AstronautView(astronaut: value)
        } label:
        {
            HStack {
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
                Text(makeListName(key: key, astronaut: value))
                Spacer()
                if sortType == .duration {
                    Text(value.duration)
                } else if sortType == .spacewalks {
                    Text(String(value.spacewalkCount))
                    //                    Text(countAstronautSpacewalks(astronaut: value))
                } else {
                    LazyHStack {
                        ForEach(badgeMissions){mission in
                            if (UIImage(named: mission.image) != nil){
                                Image("\(mission.image)_card")
                                    .resizable()
                                    .scaledToFit()
                                    .applyIf(mission.invertPatch){ content in
                                        content.colorInvert()
                                    }
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
            }
        }
    }
    func countAstronautSpacewalks(astronaut: Astronaut) -> String {
        let unsortedSpacewalks = spaceDataStore.spacewalks.values.filter { item in
        item.spacewalkers.contains { spacewalkerName in
            spacewalkerName.name == astronaut.id
            }
        }
        return String(unsortedSpacewalks.count)
    }

}
#Preview {
    let thisAstronaut = "butterworth"
    let previewDataStore = SpaceDataStore()
    AstronautListViewRepeatableChunk(
        sortType: .alphabetical,
        key: thisAstronaut,
        value: previewDataStore.astronauts[thisAstronaut]!,
        astronautMissions: previewDataStore.astronautMissionsDict[thisAstronaut]!
    ).environmentObject(previewDataStore)
}
