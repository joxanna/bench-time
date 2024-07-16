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
    
    func openSearchBenchesView(withAddress address: String) {
        searchQueryViewModel.searchText = address
        selectedTab = 1  // Switch to the SearchBenchesView tab
    }
}
