//
//  SearchBarView.swift
//  benchTime
//
//  Created by Joanna Xue on 22/6/2024.
//

import SwiftUI
import MapKit

class SearchBarUIView: UIView {
    
    let searchBar = UISearchBar()
    let backButton = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        searchBar.backgroundImage = UIImage()

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitleColor(.systemBlue, for: .normal)
        backButton.backgroundColor = UIColor.white
        backButton.isHidden = true
        
        // Customize button size
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [backButton, searchBar])
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        stackView.backgroundColor = UIColor.white
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 44)
    }
}

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

    func makeUIView(context: UIViewRepresentableContext<SearchBarView>) -> SearchBarUIView {
        let customView = SearchBarUIView()
        customView.searchBar.delegate = context.coordinator
        customView.searchBar.placeholder = placeholder
        customView.backButton.addTarget(context.coordinator, action: #selector(Coordinator.backButtonTapped), for: .touchUpInside)
        return customView
    }

    func updateUIView(_ uiView: SearchBarUIView, context: UIViewRepresentableContext<SearchBarView>) {
        uiView.searchBar.text = searchText
        if isSearching {
            uiView.backButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                uiView.backButton.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                uiView.backButton.alpha = 0.0
            }
            uiView.backButton.isHidden = true
        }
    }
    
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
            parent.onSearch(parent.searchText)
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if !searchText.isEmpty {
                parent.searchText = searchText
                searchCompleter.queryFragment = searchText
                parent.showSearchResults = true
            } else {
                parent.searchResults = []
                parent.onClear()
                parent.showSearchResults = false
            }
        }

        func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            parent.searchResults = completer.results
        }

        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            parent.isSearching = true
            parent.showSearchResults = true
        }

        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            parent.isSearching = false
            parent.showSearchResults = false
        }

        @objc func backButtonTapped() {
            // Handle back button action
            print("Back button tapped")
            parent.searchResults = []
            parent.onClear()
            parent.showSearchResults = false
        }
    }
}
