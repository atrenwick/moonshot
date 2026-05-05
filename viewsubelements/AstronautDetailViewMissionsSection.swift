//
//  AstronautDetailViewMissionsSection.swift
//  moonshot
//
//  Created by Adam on 24/04/2026.
//

import SwiftUI

struct AstronautDetailViewMissionsSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    let showRole: Bool = false
    var body: some View {
        NavigationLink{
            Text("Mission details")
            MissionView(mission: mission, astronauts: spaceDataStore.astronauts)
        } label: {
            VStack {
//                Image(systemName: "photo")
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
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
//                    Text(mission.backupcrew.)
                }
                
            }.padding(.horizontal)
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .foregroundStyle(.primary)

            
            
        }
    }
}
    
    

//#Preview {
//    AstronautDetailViewMissionsSection()
//}
