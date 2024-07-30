//
//  BTButton.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct BTButton: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(height:55)
                .frame(maxWidth: .infinity)
                .background(buttonColor())
                .cornerRadius(10)
        }
    }
    
    private func buttonColor() -> Color {
        var color: Color
        
        if isDisabled {
            color = UIStyles.Colors.disabled
        } else {
            if colorScheme == .dark {
                color =  UIStyles.Colors.Dark.link
            } else {
                color = UIStyles.Colors.Light.link
            }
        }
        
        return color
    }
}
