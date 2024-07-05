//
//  UIApplication.swift
//  benchTime
//
//  Created by Joanna Xue on 4/7/2024.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
