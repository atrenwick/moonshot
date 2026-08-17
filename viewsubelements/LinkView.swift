//
//  LinkView.swift
//  moonshot
//
//  Created by Adam on 03/06/2026.
//

import SwiftUI

struct LinkView: View {
    @Environment(\.openURL) var openURL
    var buttonText: String
    var targetURL: String
    var body: some View {
        Button(buttonText) {
            if let tidyURL = URL(string: targetURL){
                openURL(tidyURL, prefersInApp: true)
                //openURL(URL(string: targetURL)!, prefersInApp: true)
            }
        }
    }
}


struct MenuLinkView: View {
    @Environment(\.openURL) var openURL
    
    var buttonText: String
    var imageName: String?  // The SF Symbol name string
    var targetURL: String
    
    var body: some View {
        Button(action: {
            
            if let tidyURL = URL(string: targetURL) {
                // Ensure the system handles the presentation on the main thread
                openURL(tidyURL, prefersInApp: true)
                    
                //                DispatchQueue.main.async {
//                    openURL(tidyURL)
//                }
            }
        }) {
            // This replicates your precise layout: Text first, then Image
            HStack {
                if let imageNameUnwrapped =  imageName {
                    Image(systemName: imageNameUnwrapped)
                }
                Text(buttonText).fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Capsule().stroke(Color.blue, lineWidth: 1.5))
            }
        }
    }
}
