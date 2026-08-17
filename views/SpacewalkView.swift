//
//  SpacewalkView.swift
//  moonshot
//
//  Created by Adam on 20/05/2026.
//
// list view of all spacewalks with info in mission, eva number
import SwiftUI

struct SpacewalkListView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    //var thiscount: Int {spaceDataStore.spacewalks.count}
    var allSortedSpacewalks: [(key: String, value: Spacewalk)] {
        spaceDataStore.spacewalks.sorted { $0.value.number < $1.value.number }
    }
    var body: some View {

        List{
            ForEach(allSortedSpacewalks, id: \.key) { (key, value) in
                HStack{
                    Text(spaceDataStore.spacewalks[key]!.mission)
                    Spacer()
                    Text(spaceDataStore.spacewalks[key]!.id)
                    Spacer()
                    Text(String(spaceDataStore.spacewalks[key]!.spacewalkers.count))
                }
            }
        }
    }
}
#Preview {
    SpacewalkListView().environmentObject(SpaceDataStore())
}
