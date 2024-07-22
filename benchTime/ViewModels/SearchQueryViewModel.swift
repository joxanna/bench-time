//
//  SearchQueryViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 16/7/2024.
//

import SwiftUI
import Combine

class SearchQueryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var latitude: Double?
    @Published var longitude: Double?
}
