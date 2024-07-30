//
//  BTRating.swift
//  benchTime
//
//  Created by Joanna Xue on 6/7/2024.
//

import SwiftUI

struct BTRating: View {
    @Binding var rating: Double
    
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                Spacer()
                Button(action: {
                    rating = Double(index + 1)
                }) {
                    starType(for: index)
                        .resizable()
                        .foregroundColor(UIStyles.Colors.accent)
                        .frame(width: 32, height: 32)
                }
                Spacer()
            }
        }
    }
    
    private func starType(for index: Int) -> Image {
        if rating > Double(index) {
            return Image(systemName: "star.fill")
        } else {
            return Image(systemName: "star")
        }
    }
}
