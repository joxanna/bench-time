//
//  ModalView.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import SwiftUI

struct LargeModalView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String
    var contentView: Content?
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.title)
            
            contentView
            
            Button("Dismiss") {
                presentationMode.wrappedValue.dismiss()
                onDismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
