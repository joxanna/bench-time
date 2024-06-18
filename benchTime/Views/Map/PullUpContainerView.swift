//
//  PullUpContainer.swift
//  benchTime
//
//  Created by Joanna Xue on 18/6/2024.
//

import SwiftUI
import MapKit

struct PullUpContainerView: View {
    var annotationTitle: String
    var annotationSubtitle: String
    
    var body: some View {
        VStack {
            Text(annotationTitle)
                .font(.headline)
                .padding()
            Text(annotationSubtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(16)
        .padding()
        .shadow(radius: 6)
    }
}
