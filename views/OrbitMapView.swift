//
//  OrbitMapView.swift
//  moonshot
//
//  Created by Adam on 22/06/2026.
//

import SwiftUI
import Foundation
import CoreLocation
import MapKit
// groundTrack
struct OrbitMapView: View {
    var body: some View {
        let orbitTrack = generateOrbitPolyline(
            altitudeKM: 181,
            inclinationDeg: 32.2,
            raanDeg: 220.0
        )
        Map {

            MapPolyline(coordinates: orbitTrack)
                .stroke(.red, lineWidth: 3)
        }
    }
    func generateOrbitPolyline(
        altitudeKM: Double,
        inclinationDeg: Double,
        raanDeg: Double = 0.0,
        pointCount: Int = 720
    ) -> [CLLocationCoordinate2D] {

        let inclination = inclinationDeg * .pi / 180.0
        let raan = raanDeg * .pi / 180.0

        var coordinates: [CLLocationCoordinate2D] = []
        coordinates.reserveCapacity(pointCount)

        for idx in 0..<pointCount {

            let u = 2.0 * .pi * Double(idx) / Double(pointCount)

            // Circular orbit in orbital plane
            let xOrb = cos(u)
            let yOrb = sin(u)

            // Rotate by inclination
            let x1 = xOrb
            let y1 = yOrb * cos(inclination)
            let z1 = yOrb * sin(inclination)

            // Rotate by RAAN
            let x = x1 * cos(raan) - y1 * sin(raan)
            let y = x1 * sin(raan) + y1 * cos(raan)
            let z = z1

            // Convert to lat/lon
            let latitude = atan2(z, sqrt(x*x + y*y))
            let longitude = atan2(y, x)

            coordinates.append(
                CLLocationCoordinate2D(
                    latitude: latitude * 180.0 / .pi,
                    longitude: longitude * 180.0 / .pi
                )
            )
        }

        return coordinates
    }

}

#Preview {
    OrbitMapView()
}

