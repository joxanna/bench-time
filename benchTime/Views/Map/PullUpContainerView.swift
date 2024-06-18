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
    
    @GestureState private var dragState = DragState.inactive
    @State private var positionOffset: CGFloat = 0
    @State private var containerHeight: CGFloat = 200 // Initial height of the container
    
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
        .frame(height: containerHeight) // Adjusted height
        .background(Color.white)
        .cornerRadius(16)
        .padding()
        .shadow(radius: 6)
        .offset(y: max(0, dragState.translationHeight + positionOffset))
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = .dragging(translation: value.translation.height)
                }
                .onEnded { value in
                    positionOffset += value.translation.height
                    
                    // Adjust snapping threshold based on containerHeight
                    let snapDistance = containerHeight * 0.2
                    if value.translation.height > snapDistance {
                        positionOffset = containerHeight - 100 // Adjust 100 based on your content height
                    } else {
                        positionOffset = 0
                    }
                }
        )
        .edgesIgnoringSafeArea(.all)
        .animation(.easeInOut) // Optional animation
    }
    
    enum DragState {
        case inactive
        case dragging(translation: CGFloat)
        
        var translationHeight: CGFloat {
            switch self {
            case .inactive, .dragging(translation: 0):
                return 0
            case .dragging(let translation):
                return translation
            }
        }
    }
}
