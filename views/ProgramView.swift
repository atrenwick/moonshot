//
//  ProgramView.swift
//  moonshot
//
//  Created by Adam on 13/05/2026.
//

import SwiftUI

struct ProgramView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let thisProgram: String
    var programFlights: [Mission] {
        spaceDataStore.missions.filter {$0.program == thisProgram}
    }
    
    var programSpacecraft: [String] {
        var theseSpacecraft: [(String, Int)] = []
        for (spacecraftKey, spacecraftValue) in spaceDataStore.spacecrafts {
            if theseSpacecraft.contains(where: {$0.0 == spacecraftKey}) == false && spacecraftValue.program == thisProgram {
                let myTuple = (spacecraftKey, spacecraftValue.sortOrder)
                theseSpacecraft.append(myTuple)
            }
        }
        let orderedSpacecraft = theseSpacecraft
            .sorted {$0.1 < $1.1}
            .map{$0.0}
        return orderedSpacecraft
    }
    //TODO: functions: need 1 function to parse duration from string, duration ??
    var programDuration: String {
        var programCalculatedDuration: Duration = .zero
        let targetMissions: [Mission] = spaceDataStore.missions.filter {$0.program == thisProgram}
        for mission in targetMissions {
            if mission.duration.contains(":"){
                // get duration from either string or duration
                programCalculatedDuration += getDurationFromString(mission.duration).1
            } else {
                // d function
                programCalculatedDuration += getMissionAsDuration(mission.duration)
            }
        }
        let returnString = programCalculatedDuration.formatted(.units(allowed: [.days, .hours, .minutes, .seconds]))
        return returnString
    }
    
    var sortedAstronautsForProgram: ([(key: String, value: Astronaut)],Int, Dictionary<String, Int>)  {
        let programMissions = spaceDataStore.missions.filter {$0.program == thisProgram}
        var output: [(key: String, value: Astronaut)]  = []
        var foundNames: [String] = []
        var myDict: Dictionary<String,Int> = [:]
        var myScore:Int = 0
        for mission in programMissions {
            for crew in mission.crew {
                let key = crew.name
                let value = spaceDataStore.astronauts[crew.name]!
                if myDict.keys.contains(key){
                    myDict[key]! += 1  // add key if missing
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
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 80))]
        
        NavigationStack{
            ScrollView{
                Text("Program view")
                Text("Program flights total number: \(programFlights.count)")
                Text("Program flights total time \(programDuration )")
                LazyVGrid(columns: columns){
                    ForEach(programFlights, id:\.self.id){mission in
                        AstronautDetailViewMissionsSection(mission: mission)}
                }
                Text("Program astronautsCount: \(sortedAstronautsForProgram.0.count)")
                ProgramViewAstronautChunk(sortedAstronautsForProgram: sortedAstronautsForProgram)
                Text("Spaceships")
                LazyVGrid(columns: columns){
                    ForEach(0..<programSpacecraft.count){num in
                        AstronautDetailViewSpacecraftSection(spacecraftForAstronaut: programSpacecraft, num: num)
                    }
                }
            }.navigationTitle(thisProgram)
                .background(.darkBackground)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    let thisProgram: String = "Commercial Crew"
    ProgramView(thisProgram: thisProgram).environmentObject(previewStore)
}
