////
////  MapTrajectoryView.swift
////  moonshot
////
////  Created by Adam on 17/06/2026.
////
//
//import SwiftUI
//import MapKit
//import SceneKit
//
//// Model representing a point in 3D airspace
//struct FlightPoint3D: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//    let altitudeMeters: Double // MapKit prefers meters for 3D mapping
//}
//
//
//struct MapTrajectoryView: View {
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    
//    // 1. View Inputs
//    let mission: Mission
////    let startPosition: Location
////    let endPosition: Location
////    var altitudeMetres: Int // Target altitude provided in feet
////    var startCoords: CLLocationCoordinate2D
////    var endCoords: CLLocationCoordinate2D
//    
//        
////    @State var cameraPosition: MapCameraPosition
//        
//        // 2. Update the initializer to take just the Flight object
////    init(mission: Mission, spaceDataStore: SpaceDataStore) {
////            self.mission = mission
////            let calculatedStart: CLLocationCoordinate2D
////            let calculatedEnd: CLLocationCoordinate2D
////            let calculatedAlt: Int
////            
////            // 1. Safe extraction of Start Coordinates
////            if let launchLocation = spaceDataStore.launchSites[mission.launchpad] {
////                calculatedStart = launchLocation.coordinate
////            } else {
////                // Provide a safe default (e.g., Sea level / Center of map) so the compiler is happy
////                calculatedStart = CLLocationCoordinate2D(latitude: 0, longitude: 0)
////            }
////
////            // 2. Safe extraction of Target Component
////            // Using .first safely returns an optional instead of crashing if the item isn't found
////            if let components = mission.identifiedComponents,
////               let targetComponent = components.first(where: { $0.description == "First Stage" }) {
////                
////                // 3. Safe End Coordinates creation
////                let latitude = targetComponent.cutoffLat ?? "28"
////                let longitude = targetComponent.cutoffLong ?? "-75"
////                
////                if let output = mission.makeLocation(lat: latitude, long: longitude, displayName: "test1", type: "test1") {
////                    calculatedEnd = output.coordinate
////                } else {
////                    calculatedEnd = CLLocationCoordinate2D(latitude: 0, longitude: 0)
////                }
////                
////                // 4. Safe Altitude calculations
////                if let altitude = targetComponent.cutoffAlt,
////                   let thisAlt = mission.getMeasurementString(thisInt: altitude, type: .length, sourceUnit: "nm"),
////                   let asInt = Int(thisAlt) {
////                    
////                    calculatedAlt = asInt
////                } else {
////                    calculatedAlt = 50000 // Fallback if conversion chains fail
////                }
////                
////            } else {
////                // 5. CRITICAL: Provide defaults if "target1" component doesn't exist at all
////                calculatedEnd = CLLocationCoordinate2D(latitude: 0, longitude: 0)
////                calculatedAlt = 50000
////            }            // Calculate the midpoint to center the camera
////            // -------------------------------------------------------------
////            // PHASE 1 COMPLETE: Assign everything to the struct properties
////            // -------------------------------------------------------------
////            self.startCoords = calculatedStart
////            self.endCoords = calculatedEnd
////            self.altitudeMetres = calculatedAlt
////
////            let centerPoint = CLLocationCoordinate2D(
////                latitude: (startCoords.latitude + endCoords.latitude) / 2,
////                longitude: (startCoords.longitude + endCoords.longitude) / 2
////            )
////            
////            let initialCamera = MapCamera(
////                centerCoordinate: centerPoint,
////                distance: 300_000,
////                heading: 0,
////                pitch: 60.0
////            )
////            
////            self._cameraPosition = State(initialValue: .camera(initialCamera))
////        }
//    // 3. Computed trajectory math
//
////    var flightPath3D: [FlightPoint3D] {
////            // Call your Flight struct's method directly on the flight instance
//////            let targetAltitudeMeters = flight.convertToMeters()
////            let targetAltitudeMeters = Double(altitudeMetres) //Double(mission().getMeasurementString(thisInt: "37", type: .length, sourceUnit: "nm"))  // Convert feet to meters for MapKit
////            let steps = 50
////            var points: [FlightPoint3D] = []
////            
////            let startCoords = startCoords
////            let endCoords = endCoords
////            
////            for i in 0...steps {
////                let t = Double(i) / Double(steps)
////                
////                let lat = startCoords.latitude + (endCoords.latitude - startCoords.latitude) * t
////                let lon = startCoords.longitude + (endCoords.longitude - startCoords.longitude) * t
////                
////                let currentAlt = 0.0 + (targetAltitudeMeters - 0.0) * t
////                
////                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
////                points.append(FlightPoint3D(coordinate: coord, altitudeMeters: currentAlt))
////            }
////            return points
////        }
////    
////    var launchPlace: [Location] {
////        var internalList: [Location] = []
////        if let launchLocation = spaceDataStore.launchSites[mission.launchpad]{
////            internalList.append( launchLocation)
////        }
////      return internalList
////    }
////
////    var cutoff1: [Location] {
////        var internalList: [Location] = []
////        if let components = mission.identifiedComponents{
////            let thisStage = components.filter {$0.description == "First Stage"}
////            if let outputLocation =  mission.makeLocation(lat: thisStage[0].cutoffLat ?? "28.219", long: thisStage[0].cutoffLong ?? "-73.8", displayName: "S1 cutoff", type: "test11"){
////                internalList.append(outputLocation)
////            }
////        }
////        return internalList
////    }
////    
//    
//    var body: some View {
//
//        
//        Text(mission.displayName)
//        Text("cutoff")
////        Text(cutoff1[0].displayName)
////        Text(String(cutoff1[0].coordinate.latitude))
//        Text("launchplace")
////        Text(launchPlace[0].displayName)
//
////        let targetPosition  = MapCameraPosition.region(
////            MKCoordinateRegion(
////                center: launchPlace[0].coordinate,
////                span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
////            )
////        )
////
////        Map(initialPosition : targetPosition){
////            Annotation(launchPlace[0].displayName, coordinate: launchPlace[0].coordinate) {
////                Image(systemName: "star.circle.fill")
////                    .font(.title)
////                    .foregroundColor(.orange)
////                    .background(Circle().fill(.white))
////            }
////            Annotation(cutoff1[0].displayName, coordinate: cutoff1[0].coordinate) {
////                Image(systemName: "star.circle.fill")
////                    .font(.title)
////                    .foregroundColor(.green)
////                    .background(Circle().fill(.white))
////            }
////
////        }
//        
//            // We use the realistic hybrid or standard configuration with realistic elevation to unlock the 3D globe profile
////            Map(position: $cameraPosition) {
////                // Takeoff Marker
////                Marker("Start", coordinate: startCoords)
////                    .tint(.green)
////                
////                // Destination Marker
////                Marker("End", coordinate: endCoords)
////                    .tint(.red)
////                
////                // Draw the path segments
////                ForEach(0..<flightPath3D.count - 1, id: \.self) { index in
////                    let start = flightPath3D[index]
////                    let end = flightPath3D[index + 1]
////                    
////                    // Color gradient showing height (climbing out from green to blue)
////                    let ratio = start.altitudeMeters / Double(altitudeMetres)
////                    let segmentColor = Color.green.mix(with: .blue, by: ratio)
////                    
////                    MapPolyline(coordinates: [start.coordinate, end.coordinate])
////                        .stroke(segmentColor, lineWidth: 5)
////                }
////            }
////            // Force the map to load 3D terrain and buildings
////            .mapStyle(.standard(elevation: .realistic))
//        MapTrajectoryView3D(
//                        mission: mission,
//                        spaceDataStore: spaceDataStore
//                    )
//                    .frame(height: 400)
//                    .cornerRadius(12)
//                    .shadow(radius: 4)
//
//        
//    }
//}
//
//#Preview {
//    let previewStore = SpaceDataStore()
//    let theseMissions = previewStore.missions.filter {$0.name == "apollo17"}
//    if theseMissions.count > 0 {
//        MapTrajectoryView(  mission: theseMissions[0]).environmentObject(previewStore)
//        }
//        else {Text("No missions found")}
//    }
////MARK: 3d render
//
//// 1. We create a small identifiable wrapper for MapKit's underlying 3D polyline type
//struct ThreeDPathOverlay: Identifiable {
//    let id = UUID()
//    let polyline: MKPolyline
//}
//
//struct MapTrajectoryView3D: UIViewRepresentable {
//    let mission: Mission
//    let startCoords: CLLocationCoordinate2D
//    let endCoords: CLLocationCoordinate2D
//    let altitudeMetres: Int
//    
//    init(mission: Mission, spaceDataStore: SpaceDataStore) {
//            self.mission = mission
//            let calculatedStart: CLLocationCoordinate2D
//            let calculatedEnd: CLLocationCoordinate2D
//            let calculatedAlt: Int
//            
//            // 1. Safe extraction of Start Coordinates
//            if let launchLocation = spaceDataStore.launchSites[mission.launchpad] {
//                calculatedStart = launchLocation.coordinate
//            } else {
//                // Provide a safe default (e.g., Sea level / Center of map) so the compiler is happy
//                calculatedStart = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//            }
//
//            // 2. Safe extraction of Target Component
//            // Using .first safely returns an optional instead of crashing if the item isn't found
//            if let components = mission.identifiedComponents,
//               let targetComponent = components.first(where: { $0.description == "First Stage" }) {
//                
//                // 3. Safe End Coordinates creation
//                let latitude = targetComponent.cutoffLat ?? "28"
//                let longitude = targetComponent.cutoffLong ?? "-75"
//                
//                if let output = mission.makeLocation(lat: latitude, long: longitude, displayName: "test1", type: "test1") {
//                    calculatedEnd = output.coordinate
//                } else {
//                    calculatedEnd = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//                }
//                
//                // 4. Safe Altitude calculations
//                if let altitude = targetComponent.cutoffAlt,
//                   let thisAlt = mission.getMeasurementString(thisInt: altitude, type: .length, sourceUnit: "nm"),
//                   let asInt = Int(thisAlt) {
//                    
//                    calculatedAlt = asInt
//                } else {
//                    calculatedAlt = 50000000 // Fallback if conversion chains fail
//                }
//                
//            } else {
//                // 5. CRITICAL: Provide defaults if "target1" component doesn't exist at all
//                calculatedEnd = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//                calculatedAlt = 50000000
//            }            // Calculate the midpoint to center the camera
//            // -------------------------------------------------------------
//            // PHASE 1 COMPLETE: Assign everything to the struct properties
//            // -------------------------------------------------------------
//            self.startCoords = calculatedStart
//            self.endCoords = calculatedEnd
//            self.altitudeMetres = 50000000
//
//            let centerPoint = CLLocationCoordinate2D(
//                latitude: (startCoords.latitude + endCoords.latitude) / 2,
//                longitude: (startCoords.longitude + endCoords.longitude) / 2
//            )
//            
//            let initialCamera = MapCamera(
//                centerCoordinate: centerPoint,
//                distance: 300_000,
//                heading: 0,
//                pitch: 60.0
//            )
//            
////            self._cameraPosition = State(initialValue: .camera(initialCamera))
//        }
//
//    // ✅ 1. Standard calculated property lives right here
//    var flightPath3DOverlay: [MKPolygon] {
//        var polygons = [MKPolygon]()
//        let steps = 50
//        let targetAltMeters = Double(altitudeMetres)
//        
//        for i in 0..<steps {
//            let tStart = Double(i) / Double(steps)
//            let tEnd = Double(i + 1) / Double(steps)
//            
//            let latStart = startCoords.latitude + (endCoords.latitude - startCoords.latitude) * tStart
//            let lonStart = startCoords.longitude + (endCoords.longitude - startCoords.longitude) * tStart
//            let latEnd = startCoords.latitude + (endCoords.latitude - startCoords.latitude) * tEnd
//            let lonEnd = startCoords.longitude + (endCoords.longitude - startCoords.longitude) * tEnd
//            
//            let coordStart = CLLocationCoordinate2D(latitude: latStart, longitude: lonStart)
//            let coordEnd = CLLocationCoordinate2D(latitude: latEnd, longitude: lonEnd)
//            
//            // To make the curtain "wall", we define the 4 corners of the vertical slice
//            let segmentCoords = [coordStart, coordEnd, coordEnd, coordStart]
//            let polygon = MKPolygon(coordinates: segmentCoords, count: segmentCoords.count)
//            polygons.append(polygon)
//        }
//        return polygons
//    }
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic)
//        
//        // Setup initial camera angle
//        let center = CLLocationCoordinate2D(
//            latitude: (startCoords.latitude + endCoords.latitude) / 2,
//            longitude: (startCoords.longitude + endCoords.longitude) / 2
//        )
//        let camera = MKMapCamera(lookingAtCenter: center, fromDistance: 250000, pitch: 65, heading: 0)
//        mapView.setCamera(camera, animated: false)
//        
//        return mapView
//    }
//
//    // ✅ 2. This function triggers whenever the view updates or data changes
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        // Clear out old overlays so they don't pile up on top of each other
//        uiView.removeOverlays(uiView.overlays)
//        
//        // Call the calculated property and add the fresh overlays
//        uiView.addOverlays(flightPath3DOverlay)
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            if let polygon = overlay as? MKPolygon {
//                let renderer = MKPolygonRenderer(polygon: polygon)
//                renderer.fillColor = UIColor.systemRed.withAlphaComponent(0.4)
//                renderer.strokeColor = UIColor.systemRed
//                renderer.lineWidth = 2
//                return renderer
//            }
//            return MKOverlayRenderer(overlay: overlay)
//        }
//    }
//}
