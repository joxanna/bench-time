//
//  IgnoreKeyboardSafeAreaModifier.swift
//  benchTime
//
//  Created by Joanna Xue on 4/7/2024.
//
import SwiftUI

struct IgnoreKeyboardSafeAreaModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .ignoresSafeArea(.keyboard)
    }
}

extension View {
    func ignoreKeyboardSafeArea() -> some View {
        self.modifier(IgnoreKeyboardSafeAreaModifier())
    }
}
