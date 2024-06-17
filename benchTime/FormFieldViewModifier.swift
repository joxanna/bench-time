//
//  FormFieldViewModifier.swift
//  benchTime
//
//  Created by Joanna Xue on 9/5/2024.
//

import Foundation
import SwiftUI

struct FormFieldViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
}

extension View {
    func formFieldViewModifier() -> some View {
        self.modifier(FormFieldViewModifier())
    }
    
    func onSubmit(perform action: @escaping () -> Void) -> some View {
        return self.onReceive(NotificationCenter.default.publisher(for: UITextField.textDidEndEditingNotification)) { _ in
            action()
        }
    }
}
