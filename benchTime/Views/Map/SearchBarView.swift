//
//  SearchBarView.swift
//  benchTime
//
//  Created by Joanna Xue on 22/6/2024.
//

import SwiftUI

struct SearchBarView: UIViewRepresentable {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    var placeholder: String
    var onSearch: ((String) -> Void)
    var onClear: (() -> Void)

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = placeholder
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchText
        print("UPDATE SEARCH BAR VIEW, isSearching: ", isSearching)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBarView

        init(parent: SearchBarView) {
            self.parent = parent
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            parent.isSearching = true
            print("BAR CLICKED: ", parent.isSearching)
            parent.onSearch(parent.searchText)
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.searchText = searchText
            if (parent.searchText == "") {
                print("SEARCH CLEARED")
                parent.onClear()
            }
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            parent.isSearching = true
            print("BEGIN EDITING: ", parent.isSearching) // THIS TRIGGER MAP
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            parent.isSearching = false
            print("STOP EDITING CLICKED: ", parent.isSearching)
        }
    }
}
