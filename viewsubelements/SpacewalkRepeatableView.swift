//
//  SpacewalkRepeatableView.swift
//  moonshot
//
//  Created by Adam on 25/05/2026.
//

import SwiftUI

struct SpacewalkRepeatableView: View{
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let missionName: String
    let spacewalk: Spacewalk
    let num: Int
    var showSpacewalkerName: Bool = true
    var showEVAname: Bool = true
    var body: some View{
        NavigationLink{Text("\(missionName) EVA \(num+1)")
            SpaceWalkAllDetailsView(spacewalk: spacewalk)
        }
        label: {
            VStack{
                HStack{
                    if showEVAname {
                        Text("EVA \(num + 1)")
                    }
                    ForEach(spacewalk.spacewalkers){spacewalker in
                        VStack{
                            Image("\(spacewalker.name)_small")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            if showSpacewalkerName {
                                Text(spaceDataStore.astronauts[spacewalker.name]!.printSurname)
                            }
                        }
                    }
                }
            }
        }
    }
}

