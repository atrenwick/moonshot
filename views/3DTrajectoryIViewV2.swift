////
////  3DTrajectoryIView.swift
////  moonshot
////
////  Created by Adam on 18/06/2026.
//// TODO: need 3 colours for arcs :: 1 colour for powered ascent, 2 for cutoff->apex, 3 for apex > impact
//
//import SwiftUI
//import MapKit
//
//class FlightPhasePolygon: MKPolygon {
//    var colorName: String = "gray"
//    
//}
//// MARK: - 2. 3D Map View Container (UIKit Bridge)
//struct MapTrajectoryView3D: UIViewRepresentable {
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    let mission: Mission
//    
//    // added below here
//    @State var counter: Int = 0
//
//
//    
//    var paPhasesToMap: [(key: String, value: CLLocationCoordinate2D)] {
//        var returnItem: [(key: String, value: CLLocationCoordinate2D)] = []
//    
//        if let unwrappedPhases = mission.launchPhases{
//            let launchCoord =  spaceDataStore.launchSites[mission.launchpad]!.coordinate
//            let newEntry = (key: "launchpad", value: launchCoord)
//            returnItem.append(newEntry)
//            let phases = unwrappedPhases.filter {["First Stage", "Second Stage", "Third Stage"].contains ($0.description) && $0.type == "Powered Ascent"}
//            for phase in phases.sorted(by: {$0.order < $1.order}) {
//                let key = phase.type
//                if let lat = Double(phase.lat), let long = Double(phase.long){
//                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                    let phaseItem = (key: key, value: coordinate)
//                    returnItem.append(phaseItem)
//                }
//            }
//            
//        }
//        return returnItem
//    }
//    var coastPhasesToMap: [(key: String, value: CLLocationCoordinate2D)] {
//        var returnItem: [(key: String, value: CLLocationCoordinate2D)] = []
//    
//        if let unwrappedPhases = mission.launchPhases{
//            let launchCoord =  spaceDataStore.launchSites[mission.launchpad]!.coordinate
//            let newEntry = (key: "launchpad", value: launchCoord)
//            returnItem.append(newEntry)
//            let phases = unwrappedPhases.filter {["First Stage", "Second Stage", "Third Stage"].contains ($0.description) && $0.type != "Powered Ascent"}
//            for phase in phases.sorted(by: {$0.order < $1.order}) {
//                let key = phase.type
//                if let lat = Double(phase.lat), let long = Double(phase.long){
//                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//                    let phaseItem = (key: key, value: coordinate)
//                    returnItem.append(phaseItem)
//                }
//            }
//            
//        }
//        return returnItem
//    }
//    var paWalls: [[MKOverlay]] {
//        var outerList: [[MKOverlay]] = [[]]
//        
//        for (index, phase) in paPhasesToMap.enumerated(){
//            while (index + 1) < paPhasesToMap.count {
//               let theseWalls = makeFlightPath3DOverlays(nameString: "PA \(index + 1)",
//                                     startCoord: phase.value,
//                                     endCoord: paPhasesToMap[index+1].value,
//                                     steps: 100)
//                outerList.append(theseWalls)
//            }
//        }
//        return outerList
//    }
//    
//    
//    
//    
//    //added above here
//    
//    
//    
////    let targetComponents: [IdentifiedComponent]
//////    let stageDescriptorString: String
////    var startCoords: CLLocationCoordinate2D {
////        var calculatedStart: CLLocationCoordinate2D
////        // Resolve launch site start coordinates safely
////        if let launchLocation = spaceDataStore.launchSites[mission.launchpad] {
////            calculatedStart = launchLocation.coordinate
////        } else {
////            calculatedStart = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
////        }
////        return calculatedStart
////    }
////    
////    var endCoords: CLLocationCoordinate2D {
////        var calculatedEnd: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
////        // Resolve launch site start coordinates safely
////        if targetComponents.count == 1{
////            if let theseComponents = mission.identifiedComponents{
////                let endLocation = theseComponents.filter {$0.description == "First Stage"}[0]
////                if let impactLat = endLocation.impactLat{
////                    let tempLat = Int(impactLat) ?? 20
////                    if let impactLong = endLocation.impactLong{
////                        let tempLong = Int(impactLong) ?? 0
////                        let calculatedEnd = CLLocationCoordinate2D(latitude: Double(tempLat), longitude: Double(tempLong))
////                    }
////                }
////            }
////        }
////        else {
////            if let theseComponents = mission.identifiedComponents{
////                let endLocation = theseComponents.filter {$0.description == "Second Stage"}[0]
////                if let impactLat = endLocation.impactLat{
////                    let tempLat = Int(impactLat) ?? 30
////                    if let impactLong = endLocation.impactLong{
////                        let tempLong = Int(impactLong) ?? 0
////                        let calculatedEnd = CLLocationCoordinate2D(latitude: Double(tempLat), longitude: Double(tempLong))
////                    }
////                }
////            }
////        }
////        return calculatedEnd
////    }
////
////    
////    var flightPhases: [FlightPhase] {
////        var internalList: [FlightPhase] = []
////        if let output = mission.describePhases(mission: mission, components: targetComponents, using: spaceDataStore){
////            for phase in output{
////                internalList.append(phase)
////            }
////        }
////         return internalList
////    }
//    
//    // Dynamic property creating true vertical curtain wall segments
////    var flightPath3DOverlays: [MKOverlay] {
////        var walls = [MKOverlay]()
////        let steps = 100 // Higher step count makes a smoother, curved curtain wall
////        
////        for phase in flightPhases {
////            print("####################################")
////            print(phase.name)
////            for i in 0..<steps {
////                print("step\(i)")
////                let tStart = Double(i) / Double(steps)
////                let tEnd = Double(i + 1) / Double(steps)
////                print("tStart \(tStart)")
////                print("tEnd \(tEnd)")
////                // 1. Calculate positions for the start and end of this specific slice
////                let latStart = phase.startCoords.latitude + (phase.endCoords.latitude - startCoords.latitude) * tStart
////                let lonStart = phase.startCoords.longitude + (phase.endCoords.longitude - startCoords.longitude) * tStart
////                let groundCoordStart = CLLocationCoordinate2D(latitude: latStart, longitude: lonStart)
////                
////                let latEnd = phase.startCoords.latitude + (phase.endCoords.latitude - startCoords.latitude) * tEnd
////                let lonEnd = phase.startCoords.longitude + (phase.endCoords.longitude - startCoords.longitude) * tEnd
////                let groundCoordEnd = CLLocationCoordinate2D(latitude: latEnd, longitude: lonEnd)
////                print("groundCoordStart = \(groundCoordStart)")
////                print("groundCoordEnd = \(groundCoordEnd)")
////                // 2. We use MapKit's standard 2D coordinates to form a "pseudo-3D" wall slice.
////                let segmentCoords = [
////                    groundCoordStart, // Ground Start
////                    groundCoordEnd,   // Ground End
////                    groundCoordEnd,   // Sky End (Will be styled via renderer)
////                    groundCoordStart  // Sky Start
////                ]
//////                let polygon = MKPolygon(coordinates: segmentCoords, count: segmentCoords.count)
////                let polygon = FlightPhasePolygon(coordinates: segmentCoords, count: segmentCoords.count)
////                polygon.setValue(phase.name, forKey: "title")
////                walls.append(polygon)
////            }
////
////            
////        }
////        return walls
////    }
//    
//    var paPairs: [(Int, Int)] {
//        let paPairs: [(Int, Int)]
//        if ["apollo7", "skylab2", "skylab3", "skylab4"].contains(mission.name){
//            paPairs = [(0,1), (1,4)]
//        } else {
//                paPairs = [(0,1), (1,4), (4,7)]
//            }
//        return paPairs
//    }
//
//    var apexPairs: [(Int, Int)] {
//        let apexPairs: [(Int, Int)]
//        if ["apollo7", "skylab2", "skylab3", "skylab4"].contains(mission.name){
//            apexPairs = [(1,2)]
//        } else {
//            apexPairs = [(1,2), (4,5)]
//            }
//        return apexPairs
//    }
//
//    var impactPairs: [(Int, Int)] {
//        let impactPairs: [(Int, Int)]
//        if ["apollo7", "skylab2", "skylab3", "skylab4"].contains(mission.name){
//            impactPairs = [(2,3)]
//        } else {
//            impactPairs = [(2,3), (5,6)]
//            }
//        return impactPairs
//    }
//
////    var flightPath3DOverlaysV2: [MKOverlay] {
////        var walls = [MKOverlay]()
////        var setCounter: Int = -1
////        var polygonTitle: String = ""
////        let steps = 100 // Higher step count makes a smoother, curved curtain wall
////        let allPairs = [paPairs, apexPairs, impactPairs]
////        for subset in allPairs{
////            setCounter = 0
////            for pair in subset {
////                setCounter += 1
////            var startLat: Double = 0.0
////            var startLong: Double = 0.0
////            var endLat: Double = 0.0
////            var endLong: Double = 0.0
////                print("####################################")
////                print(pair.0)
////                
////                // get launchpad coords if launch else 0th element
////                if pair.0 == 0 {
////                    startLat = Double( spaceDataStore.launchSites[mission.launchpad]?.coordinate.latitude ?? 0.0)
////                    startLong = Double( spaceDataStore.launchSites[mission.launchpad]?.coordinate.longitude ?? 0.0)
////                } else {
////                    if let launchPhases = mission.launchPhases{
////                        let targetPhase = launchPhases.filter {$0.order == pair.0}[0]
////                        startLat = Double(targetPhase.lat) ?? 0
////                        startLong = Double(targetPhase.long) ?? 0
////                    }
////                    
////                }
////                if let launchPhases = mission.launchPhases{
////                    let endPhase = launchPhases.filter {$0.order == pair.1}[0]
////                    endLat = Double(endPhase.lat) ?? 0
////                    endLong = Double(endPhase.long) ?? 0
////                }
////                for i in 0..<steps {
////                    print("step\(i)")
////                    let tStart = Double(i) / Double(steps)
////                    let tEnd = Double(i + 1) / Double(steps)
////                    print("tStart \(tStart)")
////                    print("tEnd \(tEnd)")
////                    // 1. Calculate positions for the start and end of this specific slice
////                    let lat1 = startLat + (endLat - startLat) * tStart
////                    let long1 = startLong + (endLong - startLong) * tStart
////                    let groundCoordStart = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
////                    
////                    let lat2 = startLat + (endLat - startLat) * tEnd
////                    let lon2 = startLong + (endLong - startLong) * tEnd
////                    let groundCoordEnd = CLLocationCoordinate2D(latitude: lat2, longitude: lon2)
////                    print("groundCoordStart = \(groundCoordStart)")
////                    print("groundCoordEnd = \(groundCoordEnd)")
////                    // 2. We use MapKit's standard 2D coordinates to form a "pseudo-3D" wall slice.
////                    let segmentCoords = [
////                        groundCoordStart, // Ground Start
////                        groundCoordEnd,   // Ground End
////                        groundCoordEnd,   // Sky End (Will be styled via renderer)
////                        groundCoordStart  // Sky Start
////                    ]
////                    let polygon = FlightPhasePolygon(coordinates: segmentCoords, count: segmentCoords.count)
////                    if setCounter == 1{
////                        polygonTitle = "Powered Ascent"
////                    } else if setCounter == 2 {
////                        polygonTitle = "Apex"
////                    } else if setCounter == 3 {
////                        polygonTitle = "Impact"
////                    } else {
////                        polygonTitle = "error"
////                    }
////                    polygon.setValue(polygonTitle, forKey: "title")
////                    walls.append(polygon)
////                }
////                
////            }
////        }
////        return walls
////    }
//
//    
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        //add annotations
////        let annotation1 = MKPointAnnotation()
////        annotation1.title = "A11s1Impact"
////        annotation1.coordinate = CLLocationCoordinate2D(latitude: 30.012, longitude: -74.038)
////        let annotation2 = MKPointAnnotation()
////        annotation2.title =  "A11s2Impact"
////        annotation2.coordinate = CLLocationCoordinate2D(latitude: 31.535, longitude:-34.844)
////
////        let annotation3 = MKPointAnnotation()
////        annotation3.title = "A11s1Cutoff"
////        annotation3.coordinate = CLLocationCoordinate2D(latitude: 28.70, longitude: -79.69)
////        let annotation4 = MKPointAnnotation()
////        annotation4.title =  "A11s2Cutoff"
////        annotation4.coordinate = CLLocationCoordinate2D(latitude: 31.7089, longitude: -64.1983)
////
////        let annotation5 = MKPointAnnotation()
////        annotation5.title = "A11s1Apex"
////        annotation5.coordinate = CLLocationCoordinate2D(latitude: 28.87, longitude: -79.68)
////        let annotation6 = MKPointAnnotation()
////        annotation6.title =  "A11s2Apex"
////        annotation6.coordinate = CLLocationCoordinate2D(latitude: 31.7124, longitude:-64.15)
////
////        mapView.addAnnotations([annotation1, annotation2, annotation3, annotation4, annotation5, annotation6])
////        
//
//        mapView.delegate = context.coordinator
//        
//        // Force Flyover style to enable 3D depth perception
//        mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
//        
//        // Frame the flight path region
//        
//
//        let endCoords = paPhasesToMap[paPhasesToMap.count]
//        let startlat = spaceDataStore.launchSites[mission.launchpad]!.coordinate.latitude
//        let startlong = spaceDataStore.launchSites[mission.launchpad]!.coordinate.longitude
//        let endLat = endCoords.value.latitude
//        let endLong = endCoords.value.longitude
//        let center = CLLocationCoordinate2D(
//            latitude: (startlat + endLat / 2),
//            longitude: (startlong + endLong) / 2
//        )
//        
//        let camera = MKMapCamera(lookingAtCenter: center, fromDistance: 100000000, pitch: 45, heading: 1)
//        mapView.setCamera(camera, animated: false)
//        
//        return mapView
//    }
//    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        let newOverlays = paWalls.flatMap {$0}
//        if uiView.overlays.count == newOverlays.count {return}
//        
//        uiView.removeOverlays(uiView.overlays)
//        uiView.addOverlays(newOverlays)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(parent: self)
//    }
//    
//    class Coordinator: NSObject, MKMapViewDelegate {
//        let parent: MapTrajectoryView3D
//            
//            init(parent: MapTrajectoryView3D) {
//                self.parent = parent
//            }
//
//
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            let targetColor: UIColor
//            if let polygon = overlay as? FlightPhasePolygon {
//                
//                let renderer = MKPolygonRenderer(polygon: polygon)
//                if let thisTitle = polygon.title{
//                    if thisTitle.contains("Apex"){
//                        targetColor = .systemGreen
//                    } else if thisTitle.contains("Ascent"){
//                        targetColor = .systemRed
//                    } else if thisTitle.contains("Impact"){
//                        targetColor = .systemYellow
//                    } else {
//                        targetColor = .systemBrown
//                    }
//                } else {targetColor = .systemPink}
//                
//                renderer.fillColor = targetColor.withAlphaComponent(0.35)
//                renderer.strokeColor = targetColor.withAlphaComponent(0.8)
//                renderer.lineWidth = 2.0
//                
//                return renderer
//            }
//            return MKOverlayRenderer(overlay: overlay)
//        }
//    }
//    
//    func makeFlightPath3DOverlays(nameString: String, startCoord: CLLocationCoordinate2D, endCoord: CLLocationCoordinate2D, steps: Int = 100) -> [MKOverlay] {
//        var walls = [MKOverlay]()
//        let steps = steps // Higher step count makes a smoother, curved curtain wall
//        let initialLatitude = startCoord.latitude
//        let initialLongitude = startCoord.longitude
//        let finalLatitude = startCoord.latitude
//        let finalLongitude = startCoord.longitude
//        let nameString = nameString
//        
//            for i in 0..<steps {
//                let tStart = Double(i) / Double(steps)
//                let tEnd = Double(i + 1) / Double(steps)
//
//                // 1. Calculate positions for the start and end of this specific slice
//                let latStart = initialLatitude + (finalLatitude - initialLatitude) * tStart
//                let lonStart = initialLongitude + (finalLongitude - initialLongitude) * tStart
//                let groundCoordStart = CLLocationCoordinate2D(latitude: latStart, longitude: lonStart)
//                
//                let latEnd = initialLatitude + (finalLatitude - initialLatitude) * tEnd
//                let lonEnd = initialLongitude + (finalLongitude - initialLongitude) * tEnd
//                let groundCoordEnd = CLLocationCoordinate2D(latitude: latEnd, longitude: lonEnd)
//
//                // 2. We use MapKit's standard 2D coordinates to form a "pseudo-3D" wall slice.
//                let segmentCoords = [
//                    groundCoordStart, // Ground Start
//                    groundCoordEnd,   // Ground End
//                    groundCoordEnd,   // Sky End (Will be styled via renderer)
//                    groundCoordStart  // Sky Start
//                ]
//
//                let polygon = FlightPhasePolygon(coordinates: segmentCoords, count: segmentCoords.count)
//                polygon.setValue(nameString, forKey: "title")
//                
//                walls.append(polygon)
//            }
//        return walls
//    }
//
//}
//
//// MARK: - 3. Parent View
//struct ParentFlightDashboardView: View {
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    let mission: Mission
////    let component : IdentifiedComponent
//    var theseComponents: [IdentifiedComponent] {
//        var internalList: [IdentifiedComponent] = []
//        if let allComponents = mission.identifiedComponents{
//            let filteredComponents = allComponents.filter {$0.description == "First Stage" || $0.description == "Second Stage"}
//            for item in filteredComponents{
//                internalList.append(item)
//            }
//        }
//        return internalList
//    }
//    var showTitles: Bool = false
//    var body: some View {
//        VStack(spacing: 20) {
//            if showTitles {
//                Text(mission.displayName)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.top)
//                ForEach(theseComponents, id:\.self){component in
//                    Text(component.description)
//                    .font(.title3)
//                    .padding(.top)
//            }
//            }
//            // Injecting our custom 3D representable canvas directly into the interface hierarchy
//            MapTrajectoryView3D(
//                mission: mission)
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
//            .edgesIgnoringSafeArea(.bottom)
//        }
//    }
//}
//
//// MARK: - 4. Preview Provider
//#Preview {
//    let previewStore = SpaceDataStore()
//    let theseMissions = previewStore.missions.filter {$0.name == "apollo11"}
//    if theseMissions.count > 0
//    {
//        if let theseComponents = theseMissions[0].identifiedComponents{
//            let targetComponents = theseComponents.filter {$0.description == "First Stage" || $0.description == "Second Stage"}
//            
//            ParentFlightDashboardView(mission: theseMissions[0], showTitles: false).environmentObject(previewStore)
//        }
//    } else {
//        Text("No mossopms")
//    }
//}
//
