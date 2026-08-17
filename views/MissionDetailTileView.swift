//
//  MissionDetailTileView.swift
//  moonshot
//
//  Created by Adam on 16/06/2026.
//

import SwiftUI

struct MissionDetailTile: View{
    let text: String
    let useImage: String
    var imgSource: String = "sf"
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .stroke(.lightBackground, lineWidth: 2)
            VStack{
                if imgSource == "sf" {
                    Image(systemName: useImage).font(.system(size: 40))}
                else{
                    Image(useImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 40, maxHeight: 40) // for 4x grid, 45, 45
                        .padding(0)
                }
            Text(text).foregroundStyle(.primary)
                .fontWeight(.semibold)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


#Preview {
    let thisText = "Launch" // Orbit//Landing, Stats, EVAs
    let useImageString = "rocket" // network // mappin.and.ellipse.circle.fill / chart.bar.horizontal.page.fill// figure.walk
    let previewStore = SpaceDataStore()
    let theseMissions = previewStore.missions.filter {mission in
        mission.displayName.contains("MA-7")}
    if theseMissions.count > 0 {
        MissionDetailTile(text: thisText, useImage: useImageString).environmentObject(previewStore)
    } else {
        Text("No missions found")
    }
}
