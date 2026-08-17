/*
 this is a helper view to calculate rough Apex coordinates based on knowns from stage cutoff (lat, long, velocity, altitude, time) and knowns of apex (altitude, time, distance) and assuming negligible air resistance and constant g, to give a 2 dp coordinate for about where the apex would be
 
 */

////
////  CoordinateCalculateHelperView.swift
////  moonshot
////
////  Created by Adam on 20/06/2026.
////
//
//import SwiftUI
//import CoreLocation
//import Foundation
//
//struct CoordinateCalculateHelperView: View {
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    
//    let mission: Mission
//    let myList: [String] = ["First Stage", "Second Stage"]
//    
//    var outputStrings: [String] {
//        var internalList: [String] = []
//            if let missionComponents = mission.identifiedComponents{
//                let theseStages = missionComponents.filter {myList.contains ($0.description)}
//                
//                theseStages.flatMap { stage in
//                    guard let coord = calculateApexCoordinate(
//                        latitudeString: stage.cutoffLat ?? "0",
//                        longitudeString: stage.cutoffLong ?? "0",
//                        startVelocityFPS: stage.cutoffV ?? 0,
//                        currentAltitudeNMInt: stage.cutoffAltitude ?? 0,
//                        apexAltitudeNM: stage.altApex ?? 0,
//                        headingDegrees: stage.cutoffHeading ?? 0
//                    ) else {
//                        return []
//                    }
//                    
//                    internalList.append("\(mission.displayName): \(stage.description) ApexLat: \(coord.latitude)")
//                    internalList.append("\(mission.displayName): \(stage.description) ApexLong: \(coord.longitude)")
//                    
//                return internalList
//                }
//            }
//            return internalList
//        }
//    var body: some View {
////        Text(mission.displayName)
//        ForEach(outputStrings, id: \.self){string in
//            Text(string)
//        }.onAppear {
//            outputStrings.forEach { print($0) }
//        }
//        
//        
//    }
//    func calculateApexCoordinate(
//        latitudeString: String,
//        longitudeString: String,
//        startVelocityFPS: Double,
//        currentAltitudeNMInt: Int,
//        apexAltitudeNM: Double,
//        headingDegrees: Double
//    ) -> CLLocationCoordinate2D? {
//        
//        // Convert coordinate strings
//        guard let latitude = Double(latitudeString),
//              let longitude = Double(longitudeString) else {
//            return nil
//        }
//        
//        let start = CLLocationCoordinate2D(
//            latitude: latitude,
//            longitude: longitude
//        )
//        let currentAltitudeNM = Double(currentAltitudeNMInt)
//        // Constants
//        let g = 32.174
//        let feetPerNM = 6076.12
//        let earthRadiusNM = 3440.065
//        
//        let deltaHFeet = (apexAltitudeNM - currentAltitudeNM) * feetPerNM
//        
//        guard deltaHFeet > 0 else {
//            return start
//        }
//        
//        let verticalVelocity = sqrt(2.0 * g * deltaHFeet)
//        
//        let horizontalVelocity = sqrt(
//            max(
//                0.0,
//                startVelocityFPS * startVelocityFPS -
//                verticalVelocity * verticalVelocity
//            )
//        )
//        
//        let timeToApex = verticalVelocity / g
//        let distanceFeet = horizontalVelocity * timeToApex
//        let distanceNM = distanceFeet / feetPerNM
//        
//        let lat1 = latitude * .pi / 180.0
//        let lon1 = longitude * .pi / 180.0
//        let bearing = headingDegrees * .pi / 180.0
//        
//        let angularDistance = distanceNM / earthRadiusNM
//        
//        let lat2 = asin(
//            sin(lat1) * cos(angularDistance) +
//            cos(lat1) * sin(angularDistance) * cos(bearing)
//        )
//        
//        let lon2 = lon1 + atan2(
//            sin(bearing) * sin(angularDistance) * cos(lat1),
//            cos(angularDistance) - sin(lat1) * sin(lat2)
//        )
//        
//        return CLLocationCoordinate2D(
//            latitude: lat2 * 180.0 / .pi,
//            longitude: lon2 * 180.0 / .pi
//        )
//        
//    }
//}
//
//#Preview {
//    let previewStore =     SpaceDataStore()
//    let theseMissions = previewStore.missions.filter {$0.displayName == "Skylab 4"}
//    if theseMissions.count > 0{
//        CoordinateCalculateHelperView(mission: theseMissions[0]).environmentObject(previewStore)
//    } else {
//        Text("Error")
//    }
//}
