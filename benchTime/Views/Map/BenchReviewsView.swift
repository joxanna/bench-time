//
//  BenchReviewsView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/6/2024.
//

import SwiftUI
import MapKit
import SwiftOverpassAPI

struct BenchReviewsView: View {
    var bench: OPElement
    var benchAnnotation: CustomPointAnnotation

    @ObservedObject var authManager = AuthenticationManager.shared
    @StateObject var benchReviewViewModel = BenchReviewsViewViewModel()
    
    @Binding var isDismissDisabled: Bool

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    ZStack {
                        Text(benchReviewViewModel.titleText)
                            .font(.title3)
                            .bold()
                        
                        HStack {
                            Spacer()
                            NavigationLink(destination: NewReviewView(benchId: String(bench.id), latitude: benchAnnotation.coordinate.latitude, longitude: benchAnnotation.coordinate.longitude, onDismiss: {
                                benchReviewViewModel.fetchReviews(id: String(bench.id))
                            }, isDismissDisabled: $isDismissDisabled)) {
                                HStack {
                                    Image(systemName: "square.and.pencil")
                                }
                                .font(.title3)
                                .background(.clear)
                                .foregroundColor(Color.cyan)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 24)

                    // bench details
                    VStack {
                        HStack(alignment: .center) {
                            Text(benchReviewViewModel.addressText)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.bottom, 8)
                            Spacer()
                            VStack(alignment: .trailing) {
                                BTStars(rating: benchReviewViewModel.averageRating)
                                Text(String(format: "%.1f", benchReviewViewModel.averageRating))
                                    .foregroundColor(.orange)
                                    .font(.caption)
                                    .padding(.top, 4)
                            }
                        }
                        .padding(.top, 8)
                        
                        ForEach(bench.tags.sorted(by: <), id: \.key) { key, value in
                            if (key != "amenity") {
                                HStack {
                                    Image(systemName: getIcon(for: key))
                                        .frame(width: 8, height: 8)
                                    Spacer()
                                        .frame(width: 8)
                                    
                                    if (key == "two_sided") {
                                        Text("Two sided:")
                                            .bold()
                                    } else {
                                        Text("\(key.capitalized):")
                                            .bold()
                                    }
                                    
                                    if (value == "yes") {
                                        Image(systemName: "checkmark")
                                            .frame(width: 8, height: 8)
                                            .bold()
                                            .foregroundColor(.green)
                                    } else if (value == "no") {
                                        Image(systemName: "xmark")
                                            .frame(width: 8, height: 8)
                                            .bold()
                                            .foregroundColor(.red)
                                    } else {
                                        Text("\(value.capitalized)")
                                    }
                                }
                                .font(.caption)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 4)
                    }
                    .padding(.vertical, 12)
                }
                .padding(.horizontal, 20)
                
                // reviews
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let benchReviews = benchReviewViewModel.benchReviews {
                            ForEach(benchReviews) { review in
                                BTCard(review: review, currentUser: (review.uid == authManager.currentUser?.uid), address: false) {
                                    benchReviewViewModel.fetchReviews(id: String(bench.id))
                                }
                                .padding()
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            }
        }
        .onAppear {
            benchReviewViewModel.getBenchAddress(latitude: benchAnnotation.coordinate.latitude, longitude: benchAnnotation.coordinate.longitude)
            benchReviewViewModel.fetchReviews(id: String(bench.id))
        }
    }
    
    private func getIcon(for tagKey: String) -> String {
        switch tagKey {
        case "material":
            return "wrench.and.screwdriver"
        case "backrest":
            return "chair"
        case "armrest":
            return "chair.lounge"
        case "seats":
            return "person.3"
        case "colour":
            return "paintpalette"
        case "covered":
            return "umbrella"
        case "two_sided":
            return "square.2.layers.3d"
        case "direction":
            return "safari"
        case "wheelchair":
            return "accessibility"
        case "historic":
            return "book"
        case "inscription":
            return "pencil"
        default:
            return "tag"  // generic tag icon
        }
    }
}
