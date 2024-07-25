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
    @EnvironmentObject var sheetStateManager: SheetStateManager
    @StateObject var benchQueryViewModel = BenchQueryViewModel()
    @ObservedObject private var locationManager = LocationManager.shared
    
    @State private var isLoading: Bool = false
    @State private var isSelected: Bool = false
    @State private var selectedAnnotation: CustomPointAnnotation? = nil
    @State private var isSearching: Bool = false
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var showSearchResults: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    SearchBarView(
                        searchText: $searchQueryViewModel.searchText,
                        isSearching: $isSearching,
                        searchResults: $searchResults,
                        showSearchResults: $showSearchResults,
                        placeholder: "Search benches",
                        onSearch: performSearch,
                        onClear: onSearchClear
                    )
                    .frame(height: 44)
                    
                    ZStack(alignment: .top) {
                        MapView(
                            mapViewModel: benchQueryViewModel.mapViewModel,
                            onRegionChange: { region, isLoading in
                                if !isSearching && !isSelected {
                                    benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading) { _ in }
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
                            SearchResultsView(
                                searchResults: $searchResults,
                                isSearching: $isSearching,
                                onSelectResult: { result in
                                    isSearching = true
                                    searchQueryViewModel.searchText = result.uniqueIdentifier
                                    performSearch(query: searchQueryViewModel.searchText)
                                }
                            )
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
            print("SearchBenchesView appeared")
            if !searchQueryViewModel.searchText.isEmpty {
                performSearch(query: searchQueryViewModel.searchText)
            } else {
                requestLocation()
            }
        }
        .customSheet(isPresented: $isSelected, sheetContent: {
            if let annotation = selectedAnnotation,
               let bench = benchQueryViewModel.getBench(annotation: annotation) {
                BenchReviewsView(bench: bench, benchAnnotation: annotation)
            }
        }, onDismiss: {
            isSelected = false
            selectedAnnotation = nil
        })
        .onChange(of: isSelected) { _, newValue in
            if !newValue {
                isSelected = false
                selectedAnnotation = nil
            }
        }
        .onChange(of: locationManager.lastLocation) { _, _ in
            print("Location changed")
        }
        .onDisappear {
            isSelected = false
            selectedAnnotation = nil
            print("SearchBenchesView disappeared")
        }
    }
    
    private func requestLocation() {
        print("Requesting location")
        locationManager.requestLocation { location, error in
            if let error = error {
                print("Error fetching location: \(error.localizedDescription)")
                return
            }
            
            if let location = location {
                print("Location fetched: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                let region = MKCoordinateRegion(
                    center: location.coordinate,
                    latitudinalMeters: UIStyles.SearchDistance.lat,
                    longitudinalMeters: UIStyles.SearchDistance.lon
                )
                print("Setting region: \(region)")
                benchQueryViewModel.mapViewModel.region = region
                benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading) { _ in
                    print("Fetch benches completion handler called.")
                }
                print("Fetch complete")
            } else {
                print("No location available.")
            }
        }
    }
    
    private func performSearch(query: String) {
        guard !query.isEmpty else { return }
        
        benchQueryViewModel.mapViewModel.performSearch(query: query) { result in
            switch result {
            case .success:
                if let region = benchQueryViewModel.mapViewModel.region {
                    benchQueryViewModel.fetchBenches(for: region, isLoading: $isLoading) { fetchResult in
                        switch fetchResult {
                        case .failure(let error):
                            print("Fetch error: \(error.localizedDescription)")
                        case .success:
                            if let annotation = benchQueryViewModel.findAnnotation(benchId: searchQueryViewModel.benchId) {
                                isSelected = true
                                selectedAnnotation = annotation
                                benchQueryViewModel.mapViewModel.selectAnnotation(annotation, isTrackingModeFollow: true)
                                searchQueryViewModel.benchId = ""
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Search failed with error: \(error.localizedDescription)")
            }
        }
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        isSearching = false
    }
    
    private func onSearchClear() {
        searchQueryViewModel.searchText = ""
        benchQueryViewModel.mapViewModel.clearSearchPin()
    }
}
