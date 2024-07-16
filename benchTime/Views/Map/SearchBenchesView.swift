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
                    
                    SearchBarView(searchText: $searchQueryViewModel.searchText, isSearching: $isSearching, searchResults: $searchResults, showSearchResults: $showSearchResults, placeholder: "Search benches", onSearch: performSearch, onClear: onSearchClear)
                        .frame(height: 44)
                    
                    if showSearchResults {
                        SearchResultsView(searchResults: $searchResults,
                                          isSearching: $isSearching,
                                          onSelectResult: { result in
                                                isSearching = true
                                                searchQueryViewModel.searchText = result.uniqueIdentifier
                                                performSearch(query: searchQueryViewModel.searchText)
                                                print("SELECTED RESULT")
                        })
                        .padding(.top, 44)
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
            searchQueryViewModel.searchText = searchQueryViewModel.searchText // Update the search text when the view appears
            performSearch(query: searchQueryViewModel.searchText)
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
            
            if let annotation = selectedAnnotation {
                print(annotation)
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
        print("-----PERFORMING SEARCH")
        benchQueryViewModel.mapViewModel.performSearch(query: query)
        if let region = benchQueryViewModel.mapViewModel.region {
            benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading)
        }
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isSearching = false
    }
    
    private func onSearchClear() {
        print("-----CLEARING")
        searchQueryViewModel.searchText = ""
        benchQueryViewModel.mapViewModel.clearSearchPin()
    }
}
