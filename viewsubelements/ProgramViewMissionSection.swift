//
//  ProgramViewMissionSection.swift
//  moonshot
//
//  Created by Adam on 13/05/2026.
//
import SwiftUI

struct ProgramViewMissionSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    let showRole: Bool = false
    var body: some View {
        NavigationLink{
            Text("Mission details")
            MissionView(mission: mission, astronauts: spaceDataStore.astronauts)
        } label: {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .applyIf(mission.invertPatch){ content in
                        content.colorInvert()
                    }
                    .frame(width: 80)
                    .frame(minHeight: 1)
                    .clipShape(.capsule)
                    .overlay(
                        Capsule()
                            .strokeBorder(.white, lineWidth: 1)
                    )
                VStack(alignment: .leading){
                    Text(mission.displayName)
                        .foregroundStyle(.white)
                        .font(.headline)
                }
            }.padding(.horizontal)
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .foregroundStyle(.primary)
        }
    }
}
