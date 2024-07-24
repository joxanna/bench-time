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
    @Published var isPaused: Bool = false
    @Published var lastTab: Int = 0
    @Published var nextTab: Int?
 
    func openSearchBenchesView(address: String, benchId: String) {
        searchQueryViewModel.searchText = address
        searchQueryViewModel.benchId = benchId
        selectedTab = 1  // Switch to the SearchBenchesView tab
    }

    func changeTab(to tab: Int) {
        if !isPaused {
            selectedTab = tab
            print("Changed to tab: \(selectedTab), last tab: \(lastTab)")
        }
    }

    func revertTab() {
        selectedTab = lastTab
        print("Reverted to last tab: \(lastTab)")
    }
}
