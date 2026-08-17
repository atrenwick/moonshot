//
//  SpacecraftDetailViewAstronautChunk.swift
//  moonshot
//
//  Created by Adam on 23/04/2026.
//

import SwiftUI

struct SpacecraftDetailViewAstronautChunk: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let spacecraft: Spacecraft
    let sortedAstronautsForSpacecraft: ([(key: String, value: Astronaut)],Int, Dictionary<String, Int>)
    let astronautColumns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        Rectangle()
            .frame(height:2)
            .foregroundStyle(.lightBackground)
        
        Text("Astronauts")
        LazyVGrid(columns : astronautColumns) {
            let myDict = sortedAstronautsForSpacecraft.2
            ForEach(sortedAstronautsForSpacecraft.0, id: \.key) {
                (key, value) in
                NavigationLink{
                    AstronautView(astronaut: value)
                } label: {
                    VStack{
                        ZStack(alignment: .topTrailing){
                            Image(key)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 80, maxHeight: 80, alignment: .top) // Focuses on the top
                                .clipShape(.capsule)
                                .overlay(Capsule().strokeBorder(.white, lineWidth: 1))
                            if myDict[key]! > 1 {
                                let thisNum = myDict[key]!
                                Image(systemName: "\(thisNum).circle.fill").background(.white).clipShape(.circle).foregroundStyle(.blue)}
                        }
                        Text(
                            String(value.printSurname)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .allowsTightening(true)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white
                        )
                    }
                }
            } //for each
        }
    }
}
