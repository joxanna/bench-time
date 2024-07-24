//
//  Loading.swift
//  benchTime
//
//  Created by Joanna Xue on 25/7/2024.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.6))
                .frame(width: 72, height: 72)
                .cornerRadius(15)
            ProgressView()
                .frame(width: 32, height: 32)
        }
    }
}
