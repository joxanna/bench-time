//
//  RootViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 16/7/2024.
//

import SwiftUI

class RootViewViewModel: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var searchQueryViewModel = SearchQueryViewModel()
 
    func openSearchBenchesView(address: String, benchId: String) {
        searchQueryViewModel.searchText = address
        searchQueryViewModel.benchId = benchId
        selectedTab = 1 // Switch to the SearchBenchesView tab
    }
}
