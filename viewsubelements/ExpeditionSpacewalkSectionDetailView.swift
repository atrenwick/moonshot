//
//  SpacewalkSectionDetailView.swift
//  moonshot
//
//  Created by Adam on 25/05/2026.
//

import SwiftUI

struct ExpeditionSpacewalkDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let expedition: Expedition
    let expeditionSpacewalks: [Spacewalk]
    var body: some View {
        Text(expedition.displayName)
        Text("Spacewalks: \(expeditionSpacewalks.count)")
        List{
            ForEach(Array(expeditionSpacewalks.enumerated()), id:\.offset){num, evaData in
                SpacewalkRepeatableView(missionName: expedition.displayName, spacewalk: evaData, num: num)
            }
        }
    }
}
