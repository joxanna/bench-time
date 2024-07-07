//
//  HeaderView.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            Image("bench-time")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 100)
                .padding(.horizontal, 20)
            Text("by FILLET")
                .font(.caption)
                .foregroundColor(.orange)
        }
    }
}
