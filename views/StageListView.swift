//
//  StageListView.swift
//  moonshot
//
//  Created by Adam on 16/06/2026.
//

import SwiftUI

struct StageListView: View {
    @EnvironmentObject var spaceDataStore: SpaceDataStore
    var theseComponents: [IdentifiedComponent] {
        var internalList: [IdentifiedComponent] = []
        for mission in spaceDataStore.missions{
            if let theseComponents = mission.identifiedComponents{
                for comp in theseComponents{
                    if ["spacecraft", "Spacecraft", "Launch vehicle", "Launch Vehicle"].contains(comp.description) == false{
                        internalList.append(comp)
                    }
                }
            }
        }
        return internalList
    }
    var body: some View {
        NavigationStack{
            List{
                ForEach(theseComponents, id: \.self){component in
//                    if let componentCount = mission.identifiedComponents {
                    Text("\(component.serial) \(component.description)")
                    } //else {Text(String(mission.id))}
                        
                    }

            }
            
        
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let previewStore = SpaceDataStore()
    StageListView().environmentObject(previewStore)
}
//new

