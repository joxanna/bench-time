//
//  PullUpContainer.swift
//  benchTime
//
//  Created by Joanna Xue on 18/6/2024.
//

import SwiftUI
import MapKit

struct PullUpContainerView: View {
    @ObservedObject var mapViewModel: MapViewViewModel
    
    var body: some View {
        VStack {
//            Text(mapViewModel.selectedAnnotation?.title ?? "No Annotation Selected")
//                .font(.headline)
//            Text("Latitude: \(mapViewModel.selectedAnnotation?.coordinate.latitude ?? 0.0)")
//            Text("Longitude: \(mapViewModel.selectedAnnotation?.coordinate.longitude ?? 0.0)")
            
            Button(action: {
//                mapViewModel.deselectAnnotation()
            }) {
                Text("Close")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}
