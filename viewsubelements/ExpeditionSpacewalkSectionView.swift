//
//  ExpeditionSpacewalkSectionView.swift
//  moonshot
//
//  Created by Adam on 24/05/2026.
//

import SwiftUI

struct ExpeditionSpacewalkSectionView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let expedition: Expedition
    let expeditionSpacewalks: [Spacewalk]
    
    var theseSpacewalkers: [String]{  getExpeditionSpacewalkers(theseSpacewalks: expeditionSpacewalks, expedition: expedition)
    }
    
    var body: some View {
        if expeditionSpacewalks.count > 0{
                VStack{
                    Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
                VStack(alignment: .leading){
                    // show the view
                    let word2 = expeditionSpacewalks.count == 1 ? "EVA": "EVAs"
                    HStack{
                        Text("\(expeditionSpacewalks.count) \(word2)")                .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .padding(.bottom, 5)
                            .padding(.leading, 20)
                        Spacer()
                        let word3 = theseSpacewalkers.count == 1 ? "spacewalker" : "spacewalkers"
                        Text("\(theseSpacewalkers.count) \(word3)")                .font(.title3.bold())
                            .foregroundStyle(.primary)
                            .padding(.bottom, 5)
                            .padding(.leading, 20)
                    }
                    ScrollView(.horizontal){
                    HStack{
                        
                        ForEach(theseSpacewalkers, id:\.self){ spacewalkerName in
                            let thisAstronaut: Astronaut = spaceDataStore.astronauts[spacewalkerName]!
                            NavigationLink{
                                Text("EVA details")
                                ExpeditionSpacewalkDetailView(expedition: expedition, expeditionSpacewalks: expeditionSpacewalks)
                            } label: {
                                
                                VStack{
                                    Image(thisAstronaut.id)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 104, height: 72)
                                        .clipShape(.capsule)
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(.white, lineWidth: 1)
                                        )
                                    Text(thisAstronaut.printSurname)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                } //innermost vstack
                                Spacer()
                            }
                        } // hstack
                    }.padding(.horizontal)  // foreach
                    }
                } //inner vstack
                .background(.darkBackground)
                .preferredColorScheme(.dark)
            }  //outer vstack
            } // if
        
        
        //        Text(expedition.displayName)
//        Text(expedition.name)
//        Text("\((expedition.missions).count) ")
//        Text("Found \(expeditionSpacewalks.0.count) spacewalks")
//        Text("Found \(expeditionSpacewalks.1.count) spacewalkers")
//        ForEach(expeditionSpacewalks.0){thisSpacewalk in
//            HStack{
//                Text(thisSpacewalk.id)
//                Text(thisSpacewalk.spacewalkers[0].name)
//                Text(thisSpacewalk.spacewalkers[1].name)
//            }
//        }
    }
}

#Preview {
    let previewStore = SpaceDataStore()
     let thisExpedition = previewStore.expeditions.keys.filter({$0 == "mireo2"})[0]
    if let expeditionData = previewStore.expeditions[thisExpedition] {
        var spacewalksForExpedition: [Spacewalk] {
            previewStore.spacewalks.values.filter { value in
                value.mission == expeditionData.name
                }
        }

        ExpeditionSpacewalkSectionView(
            expedition: expeditionData,
            expeditionSpacewalks: spacewalksForExpedition
        ).environmentObject(SpaceDataStore())
    } else {
        Text("there was an error")
    }
}

