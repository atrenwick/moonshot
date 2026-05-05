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
        //.filter {spacecraft in
        //    spacecraft.spacecraft == spacecraftKey}
//        let currentSpacecraft = theSpacecraft[0]
        NavigationLink{
            SpacecraftDetailView(spacecraft: currentSpacecraft)
        } label: {
            
            VStack{
//                Image(systemName: "photo")
                Image(currentSpacecraft.spacecraft)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
                    .frame(height: 80)
                    .clipShape(.circle)
                    .overlay(
                        Capsule()
                            .strokeBorder(.white, lineWidth: 1)
                    )
                Text(currentSpacecraft.spacecraftName).foregroundStyle(.white)
            }.padding(.horizontal)
        }
    }
}

//#Preview {
//    AstronautDetailViewSpacecraftSection()
//}
