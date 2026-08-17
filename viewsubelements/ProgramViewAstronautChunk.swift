//
//  ProgramViewAstronautChunk.swift
//  moonshot
//
//  Created by Adam on 13/05/2026.
//
// TODO: need a dev view to export images at x dims from assets
import SwiftUI

struct ProgramViewAstronautChunk: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let sortedAstronautsForProgram: ([(key: String, value: Astronaut)],Int, Dictionary<String, Int>)
    let astronautColumns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        Rectangle()
            .frame(height:2)
            .foregroundStyle(.lightBackground)
        Text("Astronauts")
        LazyVGrid(columns : astronautColumns) {
            let myDict = sortedAstronautsForProgram.2
            ForEach(sortedAstronautsForProgram.0, id: \.key) {
                (key, value) in
                NavigationLink{
                    AstronautView(astronaut: value)
                } label: {
                    VStack{
                        ZStack(alignment: .topTrailing){
                            Image(key + "_small")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 80, maxHeight: 80, alignment: .top) // Focuses on the top
                                .clipShape(.capsule)
                                .overlay(Capsule().strokeBorder(.white, lineWidth: 1))
                            if myDict[key]! > 1 {
                                let thisNum = myDict[key]!
                                Image(systemName: "\(thisNum).circle.fill").background(.white).clipShape(.circle).foregroundStyle(.blue)}
                        }
                        Text(
                            String(value.printSurname)
                        )
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .allowsTightening(true)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white
                        )
                    }
                }
            } //for each
        }
    }
}

#Preview {
    let previewDataStore = SpaceDataStore()
    let thisProgram = "Gemini"
    var sortedAstronautsForProgram: ([(key: String, value: Astronaut)],Int, Dictionary<String, Int>)  {
        let programMissions = previewDataStore.missions.filter {$0.program == thisProgram}
        var output: [(key: String, value: Astronaut)]  = []
        var foundNames: [String] = []
        var myDict: Dictionary<String,Int> = [:]
        var myScore:Int = 0
        for mission in programMissions {
            for crew in mission.crew {
                let key = crew.name
                let value = previewDataStore.astronauts[crew.name]!
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
            }
        }
        output = output.sorted {$0.key < $1.key}
        let outputTuple = (output, myScore, myDict)
        return outputTuple
    }
    ProgramViewAstronautChunk(sortedAstronautsForProgram: sortedAstronautsForProgram).environmentObject(previewDataStore)
}
