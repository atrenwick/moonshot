//
//  Extensions.swift
//  moonshot
//
//  Created by Adam on 09/05/2026.
//

import Foundation
import SwiftUI

//MARK: extensions
extension View {
    @ViewBuilder
    func applyIf<Transformed: View>(
        _ condition: Bool,
        transform: (Self) -> Transformed
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}


//Color-theme
// extend shape style only where it's being used as a colour
extension ShapeStyle where Self == Color {
    static var darkBackground: Color {
        Color(red: 0.1, green: 0.1, blue: 0.2)
    }
    
    static var lightBackground: Color{
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
    
}

// Allows the wrapper to decode safely if the key is missing entirely from the JSON dictionary
extension KeyedDecodingContainer {
    
    // Fallback handler for numbers missing from JSON
    func decode(_ type: DefaultToZero.Type, forKey key: Key) throws -> DefaultToZero {
        try decodeIfPresent(type, forKey: key) ?? DefaultToZero()
    }
    
    // Fallback handler for units missing from JSON
    func decode(_ type: DefaultToNauticalMile.Type, forKey key: Key) throws -> DefaultToNauticalMile {
        try decodeIfPresent(type, forKey: key) ?? DefaultToNauticalMile()
    }
    
    func decode(_ type: DefaultToFeet.Type, forKey key: Key) throws -> DefaultToFeet {
        try decodeIfPresent(type, forKey: key) ?? DefaultToFeet()
    }
}



