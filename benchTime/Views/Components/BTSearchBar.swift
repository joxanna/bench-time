//
//  BTSearchBar.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//
import SwiftUI
import MapKit

struct BTSearchBar: View {
    @Binding var searchText: String
    @Binding var searchResults: [MKMapItem]

    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .formFieldViewModifier()
                .background(Color.gray.opacity(0.7))
                .onSubmit {
                    hideKeyboard()
                }

//            // Optionally display search results here
//            if (searchResults != []) {
//                List(searchResults, id: \.self) { result in
//                    Text(result.name ?? "Unknown")
//                        .background(Color.gray.opacity(0.7))
//                        .edgesIgnoringSafeArea(.all)
//                }
//            }
        }
        .cornerRadius(10)
        .padding()
//        .onChange(of: searchText) {
//            // Perform search operation whenever searchText changes
//            search()
//        }
    }

    func search() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            searchResults = response.mapItems
        }
    }
}
