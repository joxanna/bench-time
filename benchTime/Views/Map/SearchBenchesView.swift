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
    
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false // Track search state separately

    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .top) {
                    MapView(mapViewModel: benchQueryViewModel.mapViewModel,
                        onRegionChange: { region, isLoading in
                            if !isSearching && !isSelected { // Check if not searching or selected
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
                        if let newLocation = newLocation, !isSearching && !isSelected { // Check if not searching or selected
                            let region = MKCoordinateRegion(
                                center: newLocation.coordinate,
                                latitudinalMeters: UIStyles.SearchDistance.lat,
                                longitudinalMeters: UIStyles.SearchDistance.lon)
                            benchQueryViewModel.mapViewModel.region = region
                            print("-----Fetching benches in onChange")
                            benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading)
                        }
                    }
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isSearching = false
                    }
                    
                    SearchBarView(searchText: $searchText, isSearching: $isSearching, placeholder: "Search benches", onSearch: performSearch)
                }
                
                if (isLoading) {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            Spacer()
        }
        .sheet(isPresented: $isSelected, onDismiss: {
            print("-----Dismissing sheet")
            selectedAnnotation = nil
            isSelected = false
        }) {
            if let annotation = selectedAnnotation {
                if let bench = benchQueryViewModel.getBench(annotation: annotation) {
                    LargeModalView(title: "Bench reviews", contentView: BenchReviewsView(bench: bench, benchAnnotation: annotation))
                }
            }
        }
        .onChange(of: isSelected) { _,newValue in
            if !newValue {
                self.selectedAnnotation = nil
                self.isSelected = false
            }
        }
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else {
            // Handle case when search text is empty
            print("Empty query")
            return
        }
        print("-----PERFORMING SEARCH")
        // Perform search logic based on searchText
        benchQueryViewModel.mapViewModel.performSearch(query: query)
        // Fetch
        if let region = benchQueryViewModel.mapViewModel.region {
            benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading)
        }
        // Close keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isSearching = false
    }
}

