//
//  BTLink.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct BTLink: View {
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(text) {
            action()
        }
        .foregroundColor(color)
    }
}

#Preview {
    BTLink(text: "Link", color: Color.cyan) {
        // action
    }
}
