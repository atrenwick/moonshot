//
//  ApolloLaunchView.swift
//  moonshot
//
//  Created by Adam on 02/06/2026.
//

import SwiftUI
import MapKit
struct ApolloLaunchView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var displayMode: String = "serial"
    let mission: Mission
    
    var apolloImpacts: [Location] {
        var internalList: [Location] = []
        if mission.program == "Apollo"{
            if let firstStage = mission.launchPhases?.filter {$0.description == "First Stage" && $0.type == "Impact"}[0]{
                    let lat = firstStage.lat
                    let long = firstStage.long
                        if let thisLocation = mission.makeLocation(lat: lat, long: long, displayName: "", type:  ["Skylab 2", "Skylab 3", "Skylab 4", "ASTP", "Apollo 7"].contains(mission.displayName) ? "S-IB Impact": "S-IC Impact")
                        {
                            internalList.append(thisLocation)
                        }
            }
            if let secondStage = mission.launchPhases?.filter {$0.description == "Second Stage" && $0.type == "Impact"}[0]{
                let lat = secondStage.lat
                let long = secondStage.long
                        if let thisLocation = mission.makeLocation(lat: lat, long: long, displayName: "", type: "S-II Impact")
                        {
                            internalList.append(thisLocation)
                        }
            }
            if let thirdStageFiltered = mission.launchPhases?.filter( {$0.description == "Third Stage" && $0.type == "impact"}){
                if thirdStageFiltered.count > 0 {
                    let actualThirdStage = thirdStageFiltered[0]
                    let lat = actualThirdStage.lat
                    let long = actualThirdStage.long
                        if let thisLocation = mission.makeLocation(lat: lat, long: long, displayName: "SIV-B Impact", type: "")
                        {
                            internalList.append(thisLocation)
                        }
                }
            }
        }
        return internalList
    }

    // ll delta
    var lldelta: Double {
        return 170.05
    }
    
    var myImage: String {
        // settings for launch
        return "star"
    }
    let preferredOrder = ["Launch Vehicle", "First Stage", "Second Stage", "Third Stage", "IU", "SLA", "LM", "SM", "CM",  "LES"]
    let ignoreList = ["CSM Stack", "Space Vehicle"]
    let keepList = ["Launch Vehicle", "First Stage", "Second Stage", "Third Stage", "IU", "SLA", "LM", "SM", "CM",  "LES"]
    
    var orderDictionary: Dictionary<String,Int> {
        Dictionary(uniqueKeysWithValues: preferredOrder.enumerated().map { ($0.element, $0.offset) })
    }

    var sortedList: [IdentifiedComponent] {
        if let identifiedComponents = mission.identifiedComponents {
            return identifiedComponents.sorted {
                let index1 = orderDictionary[$0.description] ?? Int.max
                let index2 = orderDictionary[$1.description] ?? Int.max
                return index1 < index2
            }
        } else {  return [] }
    }
    
    
    var body: some View {
        NavigationStack{
            Text("Launched from \(mission.launchpad)")
            if let launchLocation =  spaceDataStore.launchSites[mission.launchpad]{
                let targetPosition  = MapCameraPosition.region(
                    MKCoordinateRegion(
                        center: launchLocation.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 70, longitudeDelta: 70)
                    )
                )
                Map(initialPosition : targetPosition){
                    Annotation(launchLocation.displayName, coordinate: launchLocation.coordinate) {
                        Image(systemName: "star.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                            .background(Circle().fill(.white))
                    }
                    ForEach(apolloImpacts){location in
                        Marker(location.displayName, coordinate: location.coordinate )}
                    
                    Annotation(launchLocation.displayName, coordinate: launchLocation.coordinate){
                        Image(systemName: myImage)
                            .resizable()
                            .foregroundStyle( launchLocation.type == "reported" ? .red : .green)
                            .frame(width: 24, height: 24)
                            .background(.white)
                            .clipShape(.circle)
                    }
                }.mapStyle(.imagery)
                    .frame(minHeight: 300)
                
            } // end of map
            //MARK: list of stuff
            List{
                Section(header: HStack { Text("Launch vehicle")  }) {
                    // section contents
                    if let identifiedComponents = mission.identifiedComponents{
                        ForEach(sortedList, id: \.self.serial){component in
                            if keepList.contains(component.description) {
                                NavigationLink(destination: StageDetailView(mission: mission, component: component)
                                ){
                                    StatsRepeatableElement(
                                        item: component.serial,
                                        label: component.description)
                                }
                            }
                        }
                    }
                    
                    if let theseComponents = mission.identifiedComponents{
                        let filteredComponents = theseComponents.filter {$0.description == "Third Stage"}
                        if filteredComponents.count > 0{
                            
                            if let thislong = filteredComponents[0].impactLong{
                                if thislong.hasPrefix("In") || thislong.contains("Moon"){
                                    StatsRepeatableElement(item: thislong, label: "SIV-B Location")
                                }
                            }
                        }
                    }
                }
                Section("Ascent"){
                    
                    if let launchDate =  mission.launchDate, let launchTime =  mission.launchLocal {
                            StatsRepeatableElement(item:
                                            mission.getFormattedDate(
                                                inputDate: launchDate) + " : " + launchTime ,
                                                   label: "Date")
                        }
                    if let azimuthValue =  mission.flightAzimuth{
                        StatsRepeatableElement(item: azimuthValue,
                                               label: "Launch azimuth",
                                               append: "˚",
                                               withSeparator: false)
                    }
                    
                    if let timeToEOI =  mission.sToEOI{
                        StatsRepeatableElement(item: timeToEOI,
                                               label: "Time to orbital insertion",
                                               append: "s",
                                               withSeparator: true)
                    }
                }
            }.frame(minHeight: 400)
        }
        .foregroundStyle(.primary)
    }
}
#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("Apollo 11")}
    if theseMissions.count > 0 {
        ApolloLaunchView(mission: theseMissions[0]).environmentObject(previewStore)
    } else {
        Text("No missions found in preview store.")
    }
}


//graph view of burn stages :: duration, mass
