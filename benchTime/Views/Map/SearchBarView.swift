//
//  SearchBarView.swift
//  benchTime
//
//  Created by Joanna Xue on 22/6/2024.
//

import SwiftUI
import MapKit

struct SearchBarView: UIViewRepresentable {
    @Binding var searchText: String
    @Binding var isSearching: Bool
    @Binding var searchResults: [MKLocalSearchCompletion]
    @Binding var showSearchResults: Bool
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

//    func makeUIView(context: Context) -> UIView {
//        let containerView = UIView()
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        
//        let backButton = UIButton(type: .system)
//        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        backButton.addTarget(context.coordinator, action: #selector(context.coordinator.backButtonTapped), for: .touchUpInside)
//        backButton.backgroundColor = UIColor.white
//        backButton.contentEdgeInsets = UIEdgeInsets(top: 17, left: 10, bottom: 17, right: 10)
//        backButton.isHidden = true // Initially hide the back button
//        stackView.addArrangedSubview(backButton)
//        
//        let searchBar = UISearchBar()
//        searchBar.placeholder = placeholder
//        searchBar.delegate = context.coordinator
//        stackView.addArrangedSubview(searchBar)
//        
//        containerView.addSubview(stackView)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            stackView.heightAnchor.constraint(equalToConstant: 56)
//        ])
//        
//        containerView.backgroundColor = .red
//        return containerView
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        guard let stackView = uiView.subviews.first as? UIStackView else { return }
//        guard let searchBar = stackView.arrangedSubviews.last as? UISearchBar else { return }
//
//        searchBar.text = searchText
//
//        if isSearching {
//            stackView.arrangedSubviews.first?.isHidden = false
//        } else {
//            stackView.arrangedSubviews.first?.isHidden = true
//        }
//    }
    
//    func makeUIView(context: Context) -> UIStackView {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        
//        let backButton = UIButton(type: .system)
//        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        backButton.addTarget(context.coordinator, action: #selector(context.coordinator.backButtonTapped), for: .touchUpInside)
//        backButton.backgroundColor = UIColor.white
//        backButton.contentEdgeInsets = UIEdgeInsets(top: 17, left: 10, bottom: 17, right: 10)
//        backButton.isHidden = true // Initially hide the back button
//        stackView.addArrangedSubview(backButton)
//        
//        let searchBar = UISearchBar()
//        searchBar.placeholder = placeholder
//        searchBar.delegate = context.coordinator
//        stackView.addArrangedSubview(searchBar)
//        
//        stackView.backgroundColor = .red
//        
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: stackView.superview!.topAnchor), // Adjust as needed
//            stackView.leadingAnchor.constraint(equalTo: stackView.superview!.leadingAnchor), // Adjust as needed
//            stackView.trailingAnchor.constraint(equalTo: stackView.superview!.trailingAnchor), // Adjust as needed
//            stackView.heightAnchor.constraint(equalToConstant: 56) // Adjust height as needed
//        ])
//        
//        return stackView
//    }
//    
//    func updateUIView(_ uiView: UIStackView, context: Context) {
//        guard let stackView = uiView.subviews.first as? UIStackView else { return }
//        guard let searchBar = stackView.arrangedSubviews.last as? UISearchBar else { return }
//        
//        searchBar.text = searchText
//        
//        if isSearching {
//            stackView.arrangedSubviews.first?.isHidden = false
//        } else {
//            stackView.arrangedSubviews.first?.isHidden = true
//        }
//    }

   
    class Coordinator: NSObject, UISearchBarDelegate, MKLocalSearchCompleterDelegate {
        var parent: SearchBarView
        var searchCompleter: MKLocalSearchCompleter

        init(parent: SearchBarView) {
            self.parent = parent
            self.searchCompleter = MKLocalSearchCompleter()
            
            super.init()
            self.searchCompleter.delegate = self
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            parent.isSearching = true
            print("BAR CLICKED: ", parent.isSearching)
            parent.onSearch(parent.searchText)
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            print("SEARCH TEXT DID CHANGE")
            if !searchText.isEmpty {
                parent.searchText = searchText
                searchCompleter.queryFragment = searchText
                parent.showSearchResults = true
            } else {
                print("SEARCH CLEARED")
                parent.searchResults = []
                parent.onClear()
                parent.showSearchResults = false
            }
        }
        
        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            print("UPDATE RESULTS")
            
            parent.searchResults = completer.results
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            parent.isSearching = true
            parent.showSearchResults = true
            print("BEGIN EDITING: ", parent.isSearching) // THIS TRIGGER MAP
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            parent.isSearching = false
            parent.showSearchResults = false
            print("STOP EDITING CLICKED: ", parent.isSearching)
        }
        
        @objc func backButtonTapped() {
            // Handle back button action
            print("Back button tapped")
        }
    }
}
