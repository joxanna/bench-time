//
//  BTStars.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import SwiftUI

struct BTStars: View {
    let rating: Double
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                starType(for: index)
                    .foregroundColor(UIStyles.Colors.accent)
            }
        }
    }
    
    private func starType(for index: Int) -> Image {
        let threshold = Double(index) + 0.5
        if rating >= Double(index + 1) {
            return Image(systemName: "star.fill")
        } else if rating >= threshold {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}
