//
//  SearchBenchesView.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

import SwiftUI
import MapKit
import CoreLocation
import SwiftOverpassAPI

struct SearchBenchesView: View {
    @StateObject var benchQueryViewModel = BenchQueryViewModel()
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var isSelected: Bool = false
    @State private var selectedAnnotation: CustomPointAnnotation? = nil
    
    @State private var renderCount = 0

    var body: some View {
        VStack {
            ZStack {
                MapView(mapViewModel: benchQueryViewModel.mapViewModel,
                    onRegionChange: { region in
                        if !isSelected {
                             benchQueryViewModel.fetchBenches(for: region)
                        }
                    },
                    isSelected: $isSelected,
                    selectedAnnotation: $selectedAnnotation)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation()
                }
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.lastLocation) { _, newLocation in
                    if let newLocation = newLocation, !isSelected {
                        let region = MKCoordinateRegion(
                            center: newLocation.coordinate,
                            latitudinalMeters: 300,
                            longitudinalMeters: 300)
                        benchQueryViewModel.mapViewModel.region = region
                        benchQueryViewModel.fetchBenches(for: region)
                    }
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isSelected, onDismiss: {
            print("Dimissing")
            isSelected = false
            selectedAnnotation = nil
        }) {
            if let selectedAnnotation = selectedAnnotation, let bench = benchQueryViewModel.getBench(annotation: selectedAnnotation) {
                LargeModalView(title: "Bench reviews", contentView: BenchReviewsView(bench: bench, benchAnnotation: selectedAnnotation))
            }
        }
        .onChange(of: isSelected) { _,_ in
            print("IS SELECTED: ", isSelected)
        }
    }
}
