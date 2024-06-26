//
//  SearchResultsView.swift
//  benchTime
//
//  Created by Joanna Xue on 26/6/2024.
//

import SwiftUI
import MapKit

struct SearchResultsView: View {
    @Binding var searchResults: [MKLocalSearchCompletion]
    @Binding var isSearching: Bool
    var onSelectResult: (MKLocalSearchCompletion) -> Void

    var body: some View {
        if isSearching && !searchResults.isEmpty {
            List(searchResults, id: \.uniqueIdentifier) { result in
                Button(action: {
                    onSelectResult(result)
                }) {
                    ResultCell(result: result)
                }
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return 0
                }
            }
            .listStyle(.plain)
            .listStyle(.insetGrouped) 
            .background(.white)
            .scrollContentBackground(.hidden)
        }
    }
}

struct ResultCell: View {
    let result: MKLocalSearchCompletion

    var body: some View {
        VStack(alignment: .leading) { // Adjusted alignment and spacing
            Text(result.title)
                .font(.headline)
                .foregroundStyle(.black)
                .lineLimit(nil)
            if !result.subtitle.isEmpty && result.subtitle != "Search Nearby" {
                Spacer()
                    .frame(height: 5)
                Text(result.subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(nil)
            }
        }
        .padding(.leading, 12)
        .frame(width: UIScreen.main.bounds.width, alignment: .leading)
        .frame(minHeight: 64)
    }
}


extension MKLocalSearchCompletion {
    var uniqueIdentifier: String {
        if (subtitle == "Search Nearby") {
            return title
        } else {
            return title + ", " + subtitle
        }
    }
}

