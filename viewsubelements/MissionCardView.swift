//
//  MissionCardView.swift
//  moonshot
//
//  Created by Adam on 18/04/2026.
//

import SwiftUI

struct MissionCardView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
    var endDate: String {
        let output: String = calculateEndDate(
            launchDate: mission.launchDate,
            durationString: mission.duration
        )
        return output
    }
    
    var showEndDate: Bool {
        endDate != mission.getFormattedDate(inputDate: mission.launchDate) ? true : false
    }
    var printDateString: String {
        var output: String = ""
        let thisLaunchDate = mission.getFormattedDate(inputDate: mission.launchDate)
        if showEndDate {
            let launchYear = thisLaunchDate.suffix(4)
            let landingYear = endDate.suffix(4)
            if launchYear == landingYear {
                // do this
                let start = thisLaunchDate.index(thisLaunchDate.startIndex, offsetBy: 0)
                let end = thisLaunchDate.index(thisLaunchDate.endIndex, offsetBy: -4)
                let shortened = thisLaunchDate[start..<end]
                output = "\(shortened) - \(endDate)"
            } else {
                output = "\(thisLaunchDate) - \(endDate)"
            }
        }
        else {
            output = thisLaunchDate
        }
        return output
    }
    var body: some View {
        NavigationLink{
            MissionView(mission: mission, astronauts: spaceDataStore.astronauts)
        } label: {
            VStack{
                Image("\(mission.image)_card")
                    .resizable()
                    .applyIf(mission.invertPatch){ content in
                        content.colorInvert()
                    }
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                Text(mission.displayName)
                VStack{
                    Text(printDateString)//.font(.headline).foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                        .allowsTightening(true)
                        .font(.headline).foregroundStyle(.gray)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background(.lightBackground)
            }
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10) // add rounded corners
                    .stroke(.lightBackground)
            )
        }
    }
}

#Preview{
    let mission = SpaceDataStore().missions[133]
    MissionCardView(mission: mission).environmentObject(SpaceDataStore())
}
