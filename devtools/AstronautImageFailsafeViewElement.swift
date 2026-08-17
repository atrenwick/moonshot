//
//  AstronautImageFailsafeViewElement.swift
//  moonshot
//
//  Created by Adam on 25/04/2026.
//

import SwiftUI

//struct AstronautImageFailsafeViewElement: View {
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    let astronaut: Astronaut
//    var body: some View {
//        if let remoteImagePath = astronaut.remoteImage {
//            AsyncImage(url: URL(string: remoteImagePath)) {phase in
//                if let image = phase.image {
//                    image
//                        .resizable()
//                        .scaledToFit()
//                } else if phase.error != nil {
//                    Text("There was an error loading the image.")
//                } else {
//                    ProgressView()
//                }
//            }
//                } else
//        {
//            Image(astronaut.id)
//                .resizable()
//                .scaledToFit()
//        }
//
//    }
//}
//
////#Preview {
////    AstronautImageFailsafeViewElement()
////}
//struct AstronautImageFailsafeVignette: View {
//    @EnvironmentObject var spaceDataStore: SpaceDataStore
//    let astronaut: Astronaut
//    var body: some View {
//        if let remoteImagePath = astronaut.remoteImage {
//            AsyncImage(url: URL(string: remoteImagePath)) {phase in
//                if let image = phase.image {
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(maxWidth: 80, maxHeight: 80, alignment: .top) // Focuses on the top
//                        .clipShape(.capsule)
//                        .overlay(Capsule().strokeBorder(.white, lineWidth: 1))
//                } else if phase.error != nil {
//                    Text("There was an error loading the image.")
//                } else {
//                    ProgressView()
//                }
//            }
//                } else
//        {
//            Image(astronaut.id)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(maxWidth: 80, maxHeight: 80, alignment: .top) // Focuses on the top
//                        .clipShape(.capsule)
//                        .overlay(Capsule().strokeBorder(.white, lineWidth: 1))
//        }
//
//    }
//}
