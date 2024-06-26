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
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showSearchResults: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                ZStack(alignment: .top) {
                    MapView(mapViewModel: benchQueryViewModel.mapViewModel,
                            onRegionChange: { region, isLoading in
                                if !isSearching, !isSelected { // Check if not searching or selected
                                    print("-----Fetching benches in onRegionChange")
                                    benchQueryViewModel.fetchBenches(for: region, isLoading: isLoading)
                                }
                            },
                            isSelected: $isSelected,
                            selectedAnnotation: $selectedAnnotation,
                            isLoading: $isLoading,
                            isSearching: $isSearching
                    )
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        print("STOP")
                    }
                    
                    if showSearchResults {
                        SearchResultsView(searchResults: $searchResults,
                                          isSearching: $isSearching,
                                          onSelectResult: { result in
                                                isSearching = true
                                                searchText = result.uniqueIdentifier
                                                performSearch(query: searchText)
                                                print("SELECTED RESULT")
                        })
                    }
                    
                    SearchBarView(searchText: $searchText, isSearching: $isSearching, searchResults: $searchResults, showSearchResults: $showSearchResults, placeholder: "Search benches", onSearch: performSearch, onClear: onSearchClear)
                }
                
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
            }
            Spacer()
                .frame(height: 0.5)
        }
        .onAppear {
            print("-----Requesting location on appear")
            locationManager.requestLocation { location, error in
                if let error = error {
                    print("Error fetching location: \(error.localizedDescription)")
                    return
                }
                
                if let location = location {
                    let region = MKCoordinateRegion(
                        center: location.coordinate,
                        latitudinalMeters: UIStyles.SearchDistance.lat,
                        longitudinalMeters: UIStyles.SearchDistance.lon)
                    benchQueryViewModel.mapViewModel.region = region
                    benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading)
                    print("IS FIRST RENDER")
                } else {
                    print("No location available.")
                }
            }
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
        .onChange(of: locationManager.lastLocation) { _, newLocation in

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
    
    private func onSearchClear() {
        print("-----CLEARING")
        searchText = ""
        benchQueryViewModel.mapViewModel.clearSearchPin()
    }
}

