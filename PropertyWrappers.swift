//
//  PropertyWrappers.swift
//  moonshot
//
//  Created by Adam on 17/08/2026.
//

import Foundation

@propertyWrapper
struct DefaultToZero: Codable {
    var wrappedValue: Double

    init(wrappedValue: Double = 0.0) {
        self.wrappedValue = wrappedValue
    }

    // This handles a missing key safely
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        self.wrappedValue = (try? container?.decode(Double.self)) ?? 0.0
    }
}

@propertyWrapper
struct DefaultToNauticalMile: Codable {
    var wrappedValue: String

    init(wrappedValue: String = "nm") {
        self.wrappedValue = wrappedValue
    }

    // This handles a missing key safely
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        self.wrappedValue = (try? container?.decode(String.self)) ?? "nm"
    }
}

@propertyWrapper
struct DefaultToFeet: Codable {
    var wrappedValue: String

    init(wrappedValue: String = "feet") {
        self.wrappedValue = wrappedValue
    }

    // This handles a missing key safely
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        self.wrappedValue = (try? container?.decode(String.self)) ?? "feet"
    }
}
