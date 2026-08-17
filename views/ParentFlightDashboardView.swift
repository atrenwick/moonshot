//
//  ParentFlightDashboardView.swift
//  
//
//  Created by Adam on 27/06/2026.
//

import SwiftUI
import MapKit

// MARK: - 3. Parent View
struct ParentFlightDashboardView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    let mission: Mission
//    let component : IdentifiedComponent
    var theseComponents: [IdentifiedComponent] {
        var internalList: [IdentifiedComponent] = []
        if let allComponents = mission.identifiedComponents{
            let filteredComponents = allComponents.filter {$0.description == "First Stage" || $0.description == "Second Stage"}
            for item in filteredComponents{
                internalList.append(item)
            }
        }
        return internalList
    }
    var showTitles: Bool = false
    var body: some View {
        VStack(spacing: 20) {
            if showTitles {
                Text(mission.displayName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                ForEach(theseComponents, id:\.self){component in
                    Text(component.description)
                    .font(.title3)
                    .padding(.top)
            }
            }
            // Injecting our custom 3D representable canvas directly into the interface hierarchy
            MapTrajectoryView3D(
                mission: mission,
                targetComponents: theseComponents)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

// MARK: - 4. Preview Provider
#Preview {
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {$0.name == "skylab3"}
    if theseMissions.count > 0
    {
        if let theseComponents = theseMissions[0].identifiedComponents{
            let targetComponents = theseComponents.filter {$0.description == "First Stage" || $0.description == "Second Stage"}
            
            ParentFlightDashboardView(mission: theseMissions[0], showTitles: false).environmentObject(previewStore)
        }
    } else {
        Text("No mossopms")
    }
}

