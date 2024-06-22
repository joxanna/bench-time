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
    
    @State private var isLoading: Bool = false
    @State private var isSelected: Bool = false
    @State private var selectedAnnotation: CustomPointAnnotation? = nil

    var body: some View {
        VStack {
            ZStack {
                MapView(mapViewModel: benchQueryViewModel.mapViewModel,
                    onRegionChange: { region, isLoading in
                    if !isSelected {
                            print("-----Fetching benches in onRegionChange")
                            benchQueryViewModel.fetchBenches(for: region, isLoading: isLoading)
                        }
                    },
                    isSelected: $isSelected,
                    selectedAnnotation: $selectedAnnotation,
                    isLoading: $isLoading
                )
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    print("-----Requesting location on appear")
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.lastLocation) { _, newLocation in
                    if let newLocation = newLocation, !isSelected {
                        let region = MKCoordinateRegion(
                            center: newLocation.coordinate,
                            latitudinalMeters: 300,
                            longitudinalMeters: 300)
                        benchQueryViewModel.mapViewModel.region = region
                        print("-----Fetching benches in onChange")
                        benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading)
                    }
                }
                
                if (isLoading) {
                    ProgressView()
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isSelected, onDismiss: {
            print("-----Dismissing sheet")
            isSelected = false
            selectedAnnotation = nil
        }) {
            if let annotation = selectedAnnotation {
                if let bench = benchQueryViewModel.getBench(annotation: annotation) {
                    LargeModalView(title: "Bench reviews", contentView: BenchReviewsView(bench: bench, benchAnnotation: annotation))
                }
            }
        }
        .onChange(of: isSelected) { _,_ in
        }
    }
}
