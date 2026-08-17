//
//  AstronautDetailViewSpacecraftSection.swift
//  moonshot
//
//  Created by Adam on 24/04/2026.
//

import SwiftUI

struct AstronautDetailViewSpacecraftSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    
    let spacecraftForAstronaut: [String]
    let num: Int
    var body: some View {
        
        let spacecraftKey = String(spacecraftForAstronaut[num])
        let currentSpacecraft = spaceDataStore.spacecrafts[spacecraftKey]!
        
        NavigationLink{
            SpacecraftDetailView(spacecraft: currentSpacecraft)
        } label: {
            VStack{
                Image(currentSpacecraft.spacecraft)
                    .resizable()
                    .scaledToFill()
                    .applyIf(missionShipsToInvert.contains(currentSpacecraft.spacecraft)){ content in
                        content.colorInvert()
                    }
                    .frame(width: 80)
                    .frame(height: 80)
                    .clipShape(.circle)
                    .overlay(
                        Capsule()
                            .strokeBorder(.white, lineWidth: 1)
                    )
                Text(currentSpacecraft.country == "USA" ? currentSpacecraft.spacecraftName : currentSpacecraft.spacecraft
                )
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .allowsTightening(true)
                .foregroundStyle(.white)
            }.padding(.horizontal)
        }
    }
}
