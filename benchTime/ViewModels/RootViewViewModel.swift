//
//  RootViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 16/7/2024.
//

import SwiftUI

class RootViewViewModel: ObservableObject {
    @Published var selectedTab: Int = 0  // Index of the SearchBenchesView tab
    @Published var searchQueryViewModel = SearchQueryViewModel()  // Shared view model
    
    func openSearchBenchesView(address: String, latitude: Double, longitude: Double) {
        searchQueryViewModel.searchText = address
        searchQueryViewModel.latitude = latitude
        searchQueryViewModel.longitude = longitude
        selectedTab = 1  // Switch to the SearchBenchesView tab
    }
}
