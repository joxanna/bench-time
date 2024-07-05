//
//  KeyboardAdaptiveModifier.swift
//  benchTime
//
//  Created by Joanna Xue on 4/7/2024.
//
import SwiftUI
struct KeyboardAdaptiveModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onAppear {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { notification in
                    let userInfo = notification.userInfo
                    let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
                    keyboardHeight = keyboardFrame?.height ?? 0
                }
            }
            .onDisappear {
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            }
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        self.modifier(KeyboardAdaptiveModifier())
    }
}
