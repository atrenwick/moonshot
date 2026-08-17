//
//  SpacewalkAllDetailsView.swift
//  moonshot
//
//  Created by Adam on 25/05/2026.
//
import SwiftUI

struct SpaceWalkAllDetailsView: View{
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let spacewalk: Spacewalk
    var body: some View{
        NavigationStack{
            HStack{
                ForEach(spacewalk.spacewalkers){spacewalker in
                    VStack{
                        Image(spacewalker.name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 144)
                            .clipShape(.capsule)
                            .overlay(
                                Capsule()
                                    .strokeBorder(.white, lineWidth: 1)
                            )
                        Text(spaceDataStore.astronauts[spacewalker.name]!.printSurname
                        )
                    }
                }
            }
        }
        Text("Spacewalk number \(spacewalk.number)")
        Text("Date: \(spacewalk.date)")
        Text("Duration: \(spacewalk.duration)")
        Text(spacewalk.description)
    }
}
