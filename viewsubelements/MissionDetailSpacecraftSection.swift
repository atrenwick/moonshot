//
//  MissionDetailSpacecraftSection.swift
//  moonshot
//
//  Created by Adam on 10/05/2026.
//

import SwiftUI

struct MissionDetailSpacecraftSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var showLocation: Bool = false
    var spacecraft: Spacecraft {
        spaceDataStore.spacecrafts[mission.spacecraft]!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .frame(height:2)
                .foregroundStyle(.lightBackground)
                .padding(.vertical)
            Text("Spacecraft")
                .font(.title3.bold())
                .foregroundStyle(.primary)
                .padding(.bottom, 5)
                .padding(.leading, 20)
            
            NavigationLink {
                SpacecraftDetailView(spacecraft: spacecraft)
            } label: {
                VStack(alignment: .center) {
                    
                    if let uiImage = UIImage(named: spacecraft.spacecraft) {
                        Image(spacecraft.spacecraft)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 400)
//                            .clipShape(.rect)
//                            .overlay(
//                                Rectangle()
//                                    .strokeBorder(.white, lineWidth: 1)
//                            )

                    }
                    Text("\(mission.callsign) (\(mission.spacecraft))")
                        .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .padding(.bottom, 5)
                            .padding(.leading, 20)
                    if showLocation {
                        if let manufacturer = spacecraft.manufacturer {
                            Text("In use by " + manufacturer)
                        } else {
                            Text(spacecraft.location)
                        }
                    }

                }.foregroundStyle(.white)
            }
        }
        //MARK: subsidiaryspacecraft if any
        if mission.hasSubsidiarySpaceCraft {
            let subspacecraft = spaceDataStore.subsidiarySpaceCrafts[mission.name]!
            VStack{
                Text("Lunar Module")
                    .font(.system(size: 20))
                HStack{
                    Text(subspacecraft.spacecraftName).italic()
                    Text("Serial ")
                    Text(subspacecraft.spacecraft)
                    Text("Mark ")
                    Text(subspacecraft.type)
                }
                Text(subspacecraft.location)
                Image(subspacecraft.spacecraft)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 400)
            }
        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let testMission = previewStore.missions[153]
    MissionDetailSpacecraftSection(mission: testMission).environmentObject(previewStore)
}
