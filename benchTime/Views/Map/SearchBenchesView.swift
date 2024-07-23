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
    @EnvironmentObject var searchQueryViewModel: SearchQueryViewModel
    @StateObject var benchQueryViewModel = BenchQueryViewModel()
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var isLoading: Bool = false
    @State private var isSelected: Bool = false
    @State private var selectedAnnotation: CustomPointAnnotation? = nil
    
    @State private var isSearching: Bool = false
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showSearchResults: Bool = false
    
    @State private var searchText: String = "" 
    
    init() {
        _searchText = State(initialValue: SearchQueryViewModel().searchText)  // Initialize with the default value from the view model
    }

    var body: some View {
        VStack {
            ZStack {
                VStack {
                    SearchBarView(searchText: $searchQueryViewModel.searchText, isSearching: $isSearching, searchResults: $searchResults, showSearchResults: $showSearchResults, placeholder: "Search benches", onSearch: performSearch, onClear: onSearchClear)
                        .frame(height: 44)
                    
                    ZStack(alignment: .top) {
                        MapView(mapViewModel: benchQueryViewModel.mapViewModel,
                                onRegionChange: { region, isLoading in
                                    if !isSearching, !isSelected { // Check if not searching or selected
                                        print("-----Fetching benches in onRegionChange")
                                        benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading) { result in }
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
                        }
                        
                        if showSearchResults {
                            SearchResultsView(searchResults: $searchResults,
                                              isSearching: $isSearching,
                                              onSelectResult: { result in
                                                    isSearching = true
                                                    searchQueryViewModel.searchText = result.uniqueIdentifier
                                                    performSearch(query: searchQueryViewModel.searchText)
                            })
                        }
                    }
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
            if !searchQueryViewModel.searchText.isEmpty {
                performSearch(query: searchQueryViewModel.searchText)
            } else {
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
                        benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading) { result in }
                    } else {
                        print("No location available.")
                    }
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
                    LargeModalView(contentView: BenchReviewsView(bench: bench, benchAnnotation: annotation))
                        .presentationDragIndicator(.visible)
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
            print("Empty query")
            return
        }
        
        print("-----Perfoming search")
        benchQueryViewModel.mapViewModel.performSearch(query: query) { result in
            switch result {
            case .success:
                if let region = benchQueryViewModel.mapViewModel.region {
                    benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading) { result in
                        switch result {
                        case .failure(let error):
                            print("Fetch error: \(error.localizedDescription)")
                        case .success():
                            if let annotation = benchQueryViewModel.findAnnotation(benchId: searchQueryViewModel.benchId) {
                                isSelected = true
                                selectedAnnotation = annotation
                                benchQueryViewModel.mapViewModel.selectAnnotation(annotation, isTrackingModeFollow: true)
                                // to select that annotation only once when you click on the location on the card
                                searchQueryViewModel.benchId = ""
                            }
                        }
                    }
                } else {
                    print("No region")
                }
            case .failure(let error):
                print("Search failed with error: \(error.localizedDescription)")
            }
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isSearching = false
    }
    
    private func onSearchClear() {
        print("-----Clearing")
        searchQueryViewModel.searchText = ""
        benchQueryViewModel.mapViewModel.clearSearchPin()
    }
}
