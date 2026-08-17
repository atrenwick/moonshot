//
//  PhaseDataView.swift
//  moonshot
//
//  Created by Adam on 25/06/2026.
//
import MapKit
import SwiftUI

internal import _LocationEssentials
struct PhaseDataView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    @State var counter: Int = 0

    let mission: Mission

    var paPhasesToMap: [(key: String, value: CLLocationCoordinate2D)] {
        var returnItem: [(key: String, value: CLLocationCoordinate2D)] = []
    
        if let unwrappedPhases = mission.launchPhases{
            let launchCoord =  spaceDataStore.launchSites[mission.launchpad]!.coordinate
            let newEntry = (key: "launchpad", value: launchCoord)
            returnItem.append(newEntry)
            let phases = unwrappedPhases.filter {["First Stage", "Second Stage", "Third Stage"].contains ($0.description) && $0.type == "Powered Ascent"}
            for phase in phases.sorted(by: {$0.order < $1.order}) {
                let key = phase.type
                if let lat = Double(phase.lat), let long = Double(phase.long){
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let phaseItem = (key: key, value: coordinate)
                    returnItem.append(phaseItem)
                }
            }
            
        }
        return returnItem
    }
    var coastPhasesToMap: [(key: String, value: CLLocationCoordinate2D)] {
        var returnItem: [(key: String, value: CLLocationCoordinate2D)] = []
    
        if let unwrappedPhases = mission.launchPhases{
            let launchCoord =  spaceDataStore.launchSites[mission.launchpad]!.coordinate
            let newEntry = (key: "launchpad", value: launchCoord)
            returnItem.append(newEntry)
            let phases = unwrappedPhases.filter {["First Stage", "Second Stage", "Third Stage"].contains ($0.description) && $0.type != "Powered Ascent"}
            for phase in phases.sorted(by: {$0.order < $1.order}) {
                let key = phase.type
                if let lat = Double(phase.lat), let long = Double(phase.long){
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let phaseItem = (key: key, value: coordinate)
                    returnItem.append(phaseItem)
                }
            }
            
        }
        return returnItem
    }
    var paWalls: [[MKOverlay]] {
        var outerList: [[MKOverlay]] = [[]]
        
        for (index, phase) in paPhasesToMap.enumerated(){
            while (index + 1) < paPhasesToMap.count {
               let theseWalls = makeFlightPath3DOverlays(nameString: "PA \(index + 1)",
                                     startCoord: phase.value,
                                     endCoord: paPhasesToMap[index+1].value,
                                     steps: 100)
                outerList.append(theseWalls)
            }
        }
        return outerList
    }
    
    
    
    var body: some View {
        Text("Phases : \(paPhasesToMap.count - 1)")
//        List{
//            Text(mission.saturnType ?? "NA")
//        ForEach(paPhasesToMap, id:\.self.key){ (item) in
//            Text(item.key )
//            }
        Map{
            ForEach(paPhasesToMap.enumerated(), id:\.0) {(index,dictItem) in
                // remember, launchpad is first in sequence…
                let textLabel = index == 0 ? "Launchpad" : "Stage \(index) cutoff"
                Annotation(textLabel, coordinate: dictItem.value){
                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundStyle(.red)
                        .frame(width: 24, height:24)
                        .background(.white)
                        .clipShape(.circle)
                } // marker = uses pin but can customise::
            } // foreach
            ForEach(coastPhasesToMap.enumerated(), id:\.0){(index, dictItem) in
                let textLabel = dictItem.key
                Annotation(textLabel, coordinate: dictItem.value){
                    Image(systemName: "star.circle")
                        .resizable()
                        .foregroundStyle( dictItem.key == "Apex" ? .green : .blue)
                        .frame(width: 24, height:24)
                        .background(.white)
                        .clipShape(.circle)
                } // marker = uses pin but can customise::
            } // foreach
        }
    }
    
    
    func makeFlightPath3DOverlays(nameString: String, startCoord: CLLocationCoordinate2D, endCoord: CLLocationCoordinate2D, steps: Int = 100) -> [MKOverlay] {
        var walls = [MKOverlay]()
        let steps = steps // Higher step count makes a smoother, curved curtain wall
        let initialLatitude = startCoord.latitude
        let initialLongitude = startCoord.longitude
        let finalLatitude = startCoord.latitude
        let finalLongitude = startCoord.longitude
        let nameString = nameString
        
            for i in 0..<steps {
                let tStart = Double(i) / Double(steps)
                let tEnd = Double(i + 1) / Double(steps)

                // 1. Calculate positions for the start and end of this specific slice
                let latStart = initialLatitude + (finalLatitude - initialLatitude) * tStart
                let lonStart = initialLongitude + (finalLongitude - initialLongitude) * tStart
                let groundCoordStart = CLLocationCoordinate2D(latitude: latStart, longitude: lonStart)
                
                let latEnd = initialLatitude + (finalLatitude - initialLatitude) * tEnd
                let lonEnd = initialLongitude + (finalLongitude - initialLongitude) * tEnd
                let groundCoordEnd = CLLocationCoordinate2D(latitude: latEnd, longitude: lonEnd)

                // 2. We use MapKit's standard 2D coordinates to form a "pseudo-3D" wall slice.
                let segmentCoords = [
                    groundCoordStart, // Ground Start
                    groundCoordEnd,   // Ground End
                    groundCoordEnd,   // Sky End (Will be styled via renderer)
                    groundCoordStart  // Sky Start
                ]

                let polygon = FlightPhasePolygon(coordinates: segmentCoords, count: segmentCoords.count)
                polygon.setValue(nameString, forKey: "title")
                
                walls.append(polygon)
            }
        return walls
    }

}

#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {$0.program == "Apollo"}
    if theseMissions.count > 0{
        
        PhaseDataView(mission: theseMissions[10]).environmentObject(previewStore)
    } else {
        Text("Error")
    }
    
}
