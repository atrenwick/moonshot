//
//  ExpeditionListView.swift
//  moonshot
//
//  Created by Adam on 24/05/2026.
//

import SwiftUI

struct ExpeditionListView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    var sortedExpeditions: [Expedition] {
        let allExpeditions: [Expedition] = spaceDataStore.expeditions.values.sorted {
            $0.id < $1.id
        }
        return allExpeditions
    }

    var body: some View {
        NavigationStack{
            List {
                ForEach( sortedExpeditions ) { expedition in
                    NavigationLink {
                        ExpeditionView(expedition: expedition )
                    } label: {
                        HStack{
                            Text(expedition.station)
                            Text(String(expedition.displayName))
                            Spacer()
                            Image("\(expedition.name)_small")
                                .resizable()
                                .scaledToFit()
                            
//                                .frame(maxHeight: 30)
//                            ForEach(spaceDataStore.missions.filter { mission in mission.spacecraft == spacecraft.spacecraft }.prefix(5)){ mission in
////                                        Image(systemName: "photo")
//                                Image("\(mission.image)_card")
//                                    .resizable()
//                                    .scaledToFit()
//                                    .applyIf(mission.invertPatch){ content in
//                                        content.colorInvert()
//                                    }
//                                    .frame(maxHeight: 20)
//                            } //foreach
                        }.frame(maxHeight:20)
                    } //label
                }
            }.navigationTitle("Expeditions")
        }
        .background(.darkBackground)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ExpeditionListView().environmentObject(SpaceDataStore())
}
