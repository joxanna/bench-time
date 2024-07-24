//
//  FullScreenCoverView.swift
//  benchTime
//
//  Created by Joanna Xue on 23/7/2024.
//

import SwiftUI

struct FullScreenCoverView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sheetStateManager: SheetStateManager
    @GestureState private var dragOffset = CGSize.zero
    
    let content: Content
    let onDismiss: () -> Void

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
                .updating($dragOffset) { value, state, _ in
                    if !sheetStateManager.isDismissDisabled && value.translation.height > 0 {
                        state = value.translation
                    }
                }
                .onEnded { value in
                    if !sheetStateManager.isDismissDisabled && value.translation.height > 100 {
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
