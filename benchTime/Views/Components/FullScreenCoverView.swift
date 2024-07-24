//
//  FullScreenCoverView.swift
//  benchTime
//
//  Created by Joanna Xue on 23/7/2024.
//

import SwiftUI

struct FullScreenCoverView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    @Binding var isDismissDisabled: Bool // Use @State to track dismissal state
    
    let content: Content
    let onDismiss: () -> Void

    init(isDismissDisabled: Binding<Bool>, @ViewBuilder content: () -> Content, onDismiss: @escaping () -> Void) {
        _isDismissDisabled = isDismissDisabled
        self.content = content()
        self.onDismiss = onDismiss
    }

    var body: some View {
        VStack {
            content
            Spacer()
        }
        .background(Color.white)
        .gesture(
            DragGesture()
                .updating($dragOffset) { value, state, _ in
                    if !isDismissDisabled && value.translation.height > 0 {
                        state = value.translation
                    }
                }
                .onEnded { value in
                    if !isDismissDisabled && value.translation.height > 100 {
                        dismiss()
                    }
                }
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
        onDismiss()
    }
}
