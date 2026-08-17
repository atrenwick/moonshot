//
//  FilterChipView.swift
//  moonshot
//
//  Created by Adam on 14/05/2026.
//

import SwiftUI
// this view can add a row of selectable buttons to the options in a filter when it's inside a for-each
struct FilterChipView: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    isSelected ? Color.accentColor : Color(.systemGray5)
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
