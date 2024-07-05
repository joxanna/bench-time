//
//  KeyboardResponsiveModifier.swift
//  benchTime
//
//  Created by Joanna Xue on 4/7/2024.
//

import SwiftUI
import Combine

struct KeyboardResponsiveModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    @State private var cancellable: AnyCancellable?

    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onAppear {
                self.cancellable = Publishers.Merge(
                    NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                        .map { notification in
                            (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
                        },
                    NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                        .map { _ in CGFloat(0) }
                ).assign(to: \.keyboardHeight, on: self)
            }
            .onDisappear {
                self.cancellable?.cancel()
            }
    }
}

extension View {
    func keyboardResponsive() -> some View {
        self.modifier(KeyboardResponsiveModifier())
    }
}
