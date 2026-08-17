//
//  MissionDetailPatchSection.swift
//  moonshot
//
//  Created by Adam on 10/05/2026.
//

import SwiftUI

struct MissionDetailPatchSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    
    var body: some View {
        Image(mission.image)
            .resizable()
            .scaledToFit()
            .applyIf(mission.invertPatch){ content in
                content.colorInvert()
            }
            .containerRelativeFrame(.horizontal) {width, axis in
                width * 0.6 }
        VStack(alignment: .leading){
            Rectangle()
                .frame(height:2)
                .foregroundStyle(.lightBackground)
                .padding(.vertical)
        }
    }
}
#Preview {
    let previewStore = SpaceDataStore()
    let testMission = previewStore.missions[13]
    MissionDetailPatchSection(mission: testMission).environmentObject(previewStore)
}
