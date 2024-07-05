//
//  BTNavigationItem.swift
//  benchTime
//
//  Created by Joanna Xue on 4/7/2024.
//
import SwiftUI

struct BTNavigationItem: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24, height: 24)
                .foregroundColor(color)
            Spacer()
                .frame(width: 8)
            Text("\(title)")
                .foregroundColor(color)
            Spacer()
            Image(systemName: "chevron.right")
                .frame(width: 24, height: 24)
                .foregroundColor(color)
        }
        .padding(.vertical, 12)
        .frame(height: 44)
    }
}
