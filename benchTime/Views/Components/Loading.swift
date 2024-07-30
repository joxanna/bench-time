//
//  Loading.swift
//  benchTime
//
//  Created by Joanna Xue on 25/7/2024.
//

import SwiftUI

struct Loading: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorScheme == .dark ? UIStyles.Colors.Dark.formField : UIStyles.Colors.Light.formField)
                .frame(width: 72, height: 72)
                .cornerRadius(15)
            ProgressView()
                .frame(width: 32, height: 32)
        }
    }
}
