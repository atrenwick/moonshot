//
//  SpacecraftDetailViewHeaderElement.swift
//  moonshot
//
//  Created by Adam on 23/04/2026.
//

import SwiftUI

struct SpacecraftDetailViewHeaderElement: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let inputCounts: (Int, Int)
    let spacecraft: Spacecraft
    
    var body: some View {
//        Image(systemName: "photo")
        Image(spacecraft.spacecraft)
            .resizable()
            .scaledToFill()
            .frame( maxWidth: 400)
        VStack{
            Text("Location: \(spacecraft.location)")
            Text("Astronaut count : \(inputCounts.0)")
            Text("Mission count : \(inputCounts.1)")
                if let unwrapped = spacecraft.orbits {
                    HStack{
                        Text("Orbits: ")
                        Text(unwrapped, format: .number.grouping(.automatic))
                    }
                }
                if let unwrapped = spacecraft.distance {
                    HStack {
                        Text("Distance travelled :")
                        Text(
                            Measurement(value: Double(unwrapped), unit: UnitLength.kilometers),
                            format: .measurement(width:.abbreviated)
                        )
                    }
                }
                if let unwrapped = spacecraft.flightHours {
                    HStack{
                        Text("Total flight hours: ")
                        Text(unwrapped, format: .number.grouping(.automatic))
                        Text("hours")
                    }
                }
                if let unwrapped = spacecraft.flightTime {
                    HStack{
                        Text("Flight Time: ")
                        Text(String(unwrapped))
                    }
            }
        }
    }
}

#Preview {
    let spaceDataStore = SpaceDataStore()
    SpacecraftDetailViewHeaderElement(
        inputCounts: (20, 33),
        spacecraft: spaceDataStore.spacecrafts["SC10"]!,
    ).environmentObject(SpaceDataStore())
}

