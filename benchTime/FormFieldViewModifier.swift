//
//  FormFieldViewModifier.swift
//  benchTime
//
//  Created by Joanna Xue on 9/5/2024.
//

import Foundation
import SwiftUI

struct FormFieldViewModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(colorScheme == .dark ? UIStyles.Colors.Dark.formField : UIStyles.Colors.Light.formField)
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
