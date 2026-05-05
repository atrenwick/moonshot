//
//  ContentListViewReusableSegment.swift
//  moonshot
//
//  Created by Adam on 23/04/2026.
//

import SwiftUI

struct ContentListViewReusableSegment: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var printCrewCount: Bool = false
    var body: some View {
        NavigationLink{
            MissionView(mission: mission, astronauts: spaceDataStore.astronauts)
        } label: {
            HStack{
                Text(mission.displayName)
                    .foregroundStyle(.primary)
                Spacer()
                if printCrewCount {
                    Text("Crew: \(mission.crew.count )")
                    Spacer()
                }
                //                Image(systemName: "photo")
                Image("\(mission.image)_card")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .clipShape(.circle)
                    .overlay(
                        Capsule()
                            .strokeBorder(.white, lineWidth: 1)
                    )
            }
        }
            .preferredColorScheme(.dark)
//            .padding(.horizontal)
    }
}

#Preview {
    let spaceDataStore = SpaceDataStore()
    let mission = spaceDataStore.missions[23]
    ContentListViewReusableSegment(mission: mission).environmentObject(SpaceDataStore())
}

