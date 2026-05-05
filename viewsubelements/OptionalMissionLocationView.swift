//
//  OptionalMissionLocationView.swift
//  moonshot
//
//  Created by Adam on 29/04/2026.
//
//
import SwiftUI
//
struct OptionalMissionLocationView<Item>: View {
    let locationType: String
    let location: Location?
    var body: some View {
        if location != nil {
            MissionLocationView(locationType: locationType, location: location!)
        }
        
    }
}
//
//#Preview {
//    OptionalMissionLocationView()
//}
