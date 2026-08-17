//
//  SpacewalkDetailView.swift
//  moonshot
//
//  Created by Adam on 21/05/2026.
//

import SwiftUI

struct SpacewalkDetailView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var body: some View {
        Text(mission.displayName)
        
        NavigationStack{
            if let missionEVAS = mission.missionEVAS{
                let sortedEVAS = missionEVAS.sorted {$0 < $1 }
                    Text("Spacewalks: \(missionEVAS.count)")
                    List{
                        ForEach(Array(sortedEVAS.enumerated()), id:\.offset){num, evaKey in
                            let evaData = spaceDataStore.spacewalks[evaKey]!
                            SpacewalkRepeatableView(missionName: mission.displayName, spacewalk: evaData, num: num)
                            //                        Text(String(evaData.number))
    //                        Text(evaData.date)
    //                        Text(evaData.duration)
    //                        ForEach(evaData.spacewalkers){spacewalker in
    //                            Text(spacewalker.name)
    //                        }
                    }
                }
            } else {
                Text("No EVAs")

            }
        }
    }
}
#Preview {
    let previewStore = SpaceDataStore()
    let thisMission = previewStore.missions.filter {$0.displayName.hasSuffix("mini 9")}[0]
    SpacewalkDetailView(mission: thisMission ).environmentObject(SpaceDataStore())
}
