//
//  BTButton.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct BTButton: View {
    let title: String
    let backgroundColor: Color
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
                .background(backgroundColor)
                .cornerRadius(10)
        }
    }
}
