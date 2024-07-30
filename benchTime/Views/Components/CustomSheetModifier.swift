//
//  FullScreenCoverView.swift
//  benchTime
//
//  Created by Joanna Xue on 23/7/2024.
//

import SwiftUI

struct CustomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent
    let onDismiss: () -> Void

    @State private var dragOffset: CGFloat = 0
    @State private var sheetOffset: CGFloat = UIScreen.main.bounds.height
    @State private var finalSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.75

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if isPresented {
                VStack {
                    Spacer()
                    
                    sheetContent()
                        .frame(width: UIScreen.main.bounds.width, height: finalSheetHeight)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(radius: 10)
                        .offset(y: sheetOffset + dragOffset) // Adjust based on drag
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let newOffset = value.translation.height
                                    // Allow dragging only downwards
                                    if newOffset > 0 {
                                        dragOffset = newOffset
                                    }
                                }
                                .onEnded { value in
                                    // Dismiss if drag exceeds threshold
                                    if dragOffset > 100 {
                                        dismiss()
                                    } else {
                                        withAnimation {
                                            dragOffset = 0
                                        }
                                    }
                                }
                        )
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isPresented) // Animate when the sheet is presented
                        .onAppear {
                            withAnimation(.spring()) { // Animate the appearance
                                sheetOffset = 0
                            }
                        }
                        .onDisappear {
                            // Reset the offset when the sheet disappears
                            sheetOffset = UIScreen.main.bounds.height
                        }
                }
            }
        }
    }

    private func dismiss() {
        withAnimation {
            isPresented = false
            dragOffset = 0
        }
        onDismiss()
    }
}

extension View {
    func customSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetContent: @escaping () -> SheetContent,
        onDismiss: @escaping () -> Void = {}
    ) -> some View {
        self.modifier(CustomSheetModifier(isPresented: isPresented, sheetContent: sheetContent, onDismiss: onDismiss))
    }
}
