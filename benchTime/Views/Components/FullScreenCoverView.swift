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
    let content: Content
    let onDismiss: () -> Void

    @State private var showAlert = false

    init(@ViewBuilder content: () -> Content, onDismiss: @escaping () -> Void) {
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
                .updating($dragOffset, body: { (value, state, transaction) in
                    if value.translation.height > 0 {
                        state = value.translation
                    }
                })
                .onEnded { value in
                    if value.translation.height > 100 {
                        showAlert = true
                    }
                }
        )
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to discard changes?"),
                primaryButton: .destructive(Text("Discard")) {
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
        onDismiss()
    }
}
