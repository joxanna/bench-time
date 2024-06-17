//
//  LabelViewModifier.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import Foundation
import SwiftUI
struct LabelViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.leading)
    }
}

extension View {
    func labelViewModifier() -> some View {
        self.modifier(LabelViewModifier())
    }
}
