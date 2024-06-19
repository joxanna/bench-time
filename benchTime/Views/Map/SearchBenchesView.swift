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
    
    @State private var selectedAnnotation: CustomPointAnnotation?
    @State private var isSelected: Bool = false
    @State private var bench: OPElement?

    var body: some View {
        VStack {
            ZStack {
                MapView(mapViewModel: benchQueryViewModel.mapViewModel, onRegionChange: { region in
                    benchQueryViewModel.fetchBenches(for: region)
                }, selectedAnnotation: $selectedAnnotation, isSelected: $isSelected)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.lastLocation) { _, newLocation in
                    if let newLocation = newLocation {
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
        .sheet(isPresented: $isSelected) {
            if let selectedAnnotation = selectedAnnotation, let bench = benchQueryViewModel.getBench(annotation: selectedAnnotation) {
                LargeModalView(title: "Bench reviews", contentView: BenchReviewsView(bench: bench, benchAnnotation: selectedAnnotation)) {
                }
            }
        }
        .onChange(of: selectedAnnotation) { _, newAnnotation in
            if let newAnnotation = newAnnotation {
                bench = benchQueryViewModel.getBench(annotation: newAnnotation)
            }
        }
    }
}
