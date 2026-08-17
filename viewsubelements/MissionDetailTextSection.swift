//
//  MissionDetailTextSection.swift
//  moonshot
//
//  Created by Adam on 10/05/2026.
//

import SwiftUI
internal import _LocationEssentials

struct MissionDetailTextSection: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @Environment(\.openURL) var openURL
    var refDocs: [RefDoc]  {
        spaceDataStore.referenceDocuments.filter {$0.mission == mission.name}
    }
    
    let mission: Mission
    var body: some View {
        VStack{
            Text("Overview").font(.title.bold())
            Text("Launch: \( mission.getFormattedDate(inputDate: mission.launchDate))")
            Text("Launchpad: \(mission.launchpad)")
            
            if let crewcount = mission.crewCount{
                Text("Crew Count = \(crewcount)")
            }

            if let hasLanded = mission.landingDate{
                HStack{
                    Text("Landing:")
                    let displayText = getLandingSiteShort(spaceDataStore: spaceDataStore, mission: mission)
                    if displayText != ""{
                        Text(displayText)
                    }
                }
            Text("Duration: \(mission.duration)")
            }
            //MARK: links
//                    Text("Links")
                    
                    // ensure there is a link somewhere
                    if mission.urlPressKitRaw != nil || mission.missionReportURL != nil ||
                        mission.missionOperationReportURL != nil || mission.launchVehicleEvalURL != nil || mission.techDebriefVolume1URL != nil || mission.techDebriefVolume2URL != nil || mission.prelimSciReportURL != nil {
                        Rectangle()
                            .frame(height:2)
                            .foregroundStyle(.lightBackground)
                        
                        ScrollView(.horizontal){
                            HStack(alignment: .center){
                        
                                Menu {
                                    if refDocs.count > 0  {
                                        ForEach(refDocs) {entry in
                                        MenuLinkView(
                                            buttonText: entry.description,
                                            imageName: "receipt.fill",
                                            targetURL: entry.url
                                        )
                                    }
                                    }
                                }
                             label: {
                                Label("Reports", systemImage: "link.circle")
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        Capsule()
                                            .stroke(Color.blue, lineWidth: 1.5) // Clean border line
                                    )
                            }
                            
//                        Menu {
//                            if let missionReportLink = mission.missionReportURL {
//                                MenuLinkView(
//                                    buttonText: "Mission Report",
//                                    imageName: "receipt.fill",
//                                    targetURL: missionReportLink
//                                )
//                            }
//                            
//                            if let missionOpsReportLink = mission.missionOperationReportURL {
//                                MenuLinkView(
//                                    buttonText: "Mission Operations Report",
//                                    imageName: "pencil.and.list.clipboard",
//                                    targetURL: missionOpsReportLink
//                                )
//                            }
//                            if let lvEvalLink = mission.launchVehicleEvalURL {
//                                MenuLinkView(
//                                    buttonText: "LV Evaluation Report",
//                                    imageName: "square.and.arrow.up.badge.clock.fill",
//                                    targetURL: lvEvalLink
//                                )
//                            }
//                            
//                            if let debriefLink = mission.techDebriefVolume1URL {
//                                MenuLinkView(
//                                    buttonText: "Technical Debrief",
//                                    imageName: "compass.drawing",
//                                    targetURL: debriefLink
//                                )
//                            }
//                            if let debriefLink2 = mission.techDebriefVolume2URL {
//                                MenuLinkView(
//                                    buttonText: "Technical Debrief Vol 2",
//                                    imageName: "compass.drawing",
//                                    targetURL: debriefLink2
//                                )
//                            }
//                            
//                            if let sciReportLink = mission.prelimSciReportURL {
//                                MenuLinkView(
//                                    buttonText: "Preliminary Science Report",
//                                    imageName: "atom",
//                                    targetURL: sciReportLink
//                                )
//                            }
//                            
//                        } label: {
//                            Label("Reports", systemImage: "link.circle")
//                                .fontWeight(.medium)
//                                .foregroundColor(.blue)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 16)
//                                .background(
//                                    Capsule()
//                                        .stroke(Color.blue, lineWidth: 1.5) // Clean border line
//                                )
//                        }
                        
                        if let urlPressKitLink = mission.urlPressKitRaw {
                            MenuLinkView(buttonText: "Press Kit",  targetURL: urlPressKitLink)
                        }
                        if let wikiLink = mission.urlWikiRaw{
                            MenuLinkView(buttonText: "Wikipedia", targetURL: wikiLink)
                        }
                        if let nasaLink = mission.urlNASA{
                            MenuLinkView(buttonText: "NASA page", targetURL: nasaLink)
                        }
                        if let spacefactsLink = mission.urlSpacefactsRaw{
                            MenuLinkView(buttonText: "Spacefacts page", targetURL: spacefactsLink)
                        }

                    }
                }.padding(.horizontal)
            }


        }
        Rectangle()
        .frame(height:2)
        .foregroundStyle(.lightBackground)

        if (mission.description).count > 1
        {
            VStack{
                Text("Mission Summary").font(.title.bold())
                    .padding(.bottom, 5)
                Text(mission.description)
                Rectangle()
                    .frame(height:2)
                    .foregroundStyle(.lightBackground)
            }
            .padding(.horizontal)
        }
    
    }
    
    
}
#Preview {
    let previewStore = SpaceDataStore()
    let testMission = previewStore.missions.filter {$0.displayName == "Apollo 8"}[0]
//    let testMission = previewStore.missions[283]
    MissionDetailTextSection(mission: testMission).environmentObject(previewStore)
}


