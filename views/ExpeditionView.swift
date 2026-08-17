//
//  ExpeditionView.swift
//  moonshot
//
//  Created by Adam on 24/05/2026.
//

import SwiftUI

struct ExpeditionView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let expedition: Expedition
    
    var spacewalksForExpedition: [Spacewalk] {
        var targetSpacewalks:[Spacewalk] = spaceDataStore.spacewalks.values.filter { value in
            value.mission == expedition.name
        }
        return targetSpacewalks.sorted {$0.number < $1.number}
        
    }
    
    var sortedAstronautsForExpedition: ([(key: String, value: Astronaut)],Int, Dictionary<String, Int>)  {
        var output: [(key: String, value: Astronaut)]  = []
        var foundNames: [String] = []
        var myDict: Dictionary<String,Int> = [:]
        var myScore:Int = 0
        for astronautString in expedition.astronauts {
            let key = astronautString
            if let value = spaceDataStore.astronauts[astronautString]
            {
                // add key if missing
                if myDict.keys.contains(key){
                    myDict[key]! += 1
                }
                if myDict.keys.contains(key) == false {
                    myScore += 1
                    myDict[key] = 1
                }
                if foundNames.contains(key) == false {
                    output.append(
                        (key: key, value: value))
                    foundNames.append(key)
                }
            } else {print("missing::expedition\(expedition.name):: astronautstring \(astronautString)")}
        }
        output = output.sorted {$0.key < $1.key}
        let outputTuple = (output, myScore, myDict)
        return outputTuple
    }
    
    var body: some View {
        NavigationStack{
            ScrollView {
                Text("\(expedition.station) \(expedition.displayName)")
                    .font(.title3.bold())
                Image(expedition.name)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                
                //                .containerRelativeFrame(.horizontal) {width, axis in
                //                    width * 1.0 }
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
                Text("Missions").fontWeight(.semibold)
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(expedition.missions, id:\.self){mission in
                            let missionData = spaceDataStore.missions.filter {$0.name == mission}[0]
                            AstronautDetailViewMissionsSection(mission: missionData)
                        }
                    }
                }.frame(maxWidth: .infinity)
                
                SpacecraftDetailViewAstronautChunk(
                    spacecraft: spaceDataStore.spacecrafts["CS212"]!, // spacecraft isn't used here, so can use dummy
                    sortedAstronautsForSpacecraft: sortedAstronautsForExpedition
                )
                if spacewalksForExpedition.count > 0
                {   let word2 = spacewalksForExpedition.count == 1 ? "spacewalk": "spacewalks"
                    Text("\(spacewalksForExpedition.count) \(word2)")
                    ExpeditionSpacewalkSectionView(expedition: expedition, expeditionSpacewalks: spacewalksForExpedition)
                }
            }}
        //        .navigationTitle("foobar").foregroundStyle(.primary)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
        .preferredColorScheme(.dark)
    }
}
#Preview {
    let previewStore = SpaceDataStore()
    if let expeditionData = previewStore.expeditions["expedition65"] {
        ExpeditionView(expedition: expeditionData).environmentObject(SpaceDataStore())
    } else {
        Text("error")
    }
}
