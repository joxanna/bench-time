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
    @ObservedObject var benchReviewViewModel = BenchReviewsViewViewModel()

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    if let benchReviews = benchReviewViewModel.benchReviews {
                        if benchReviews.count == 1 {
                            Text("\(benchReviews.count) review")
                                .font(.title3)
                                .bold()
                        } else {
                            Text("\(benchReviews.count) reviews")
                                .font(.title3)
                                .bold()
                        }
                    }
                }
                .padding(.top, 24)
                
                HStack {
                    BTStars(rating: benchReviewViewModel.averageRating)
                    Text(benchReviewViewModel.ratingText)
                        .foregroundColor(.orange)
                        .font(.caption)
                }

                HStack {
                    Text(benchReviewViewModel.addressText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    NavigationLink(destination: NewReviewView(benchId: String(bench.id), latitude: benchAnnotation.coordinate.latitude, longitude: benchAnnotation.coordinate.longitude)) {
                        HStack {
                            Text("New Review")
                            Image(systemName: "square.and.pencil")
                        }
                        .font(.subheadline)
                        .padding(12)
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        if let benchReviews = benchReviewViewModel.benchReviews {
                            ForEach(benchReviews) { review in
                                BTCard(review: review, currentUser: (review.uid == authManager.currentUser?.uid), address: false) {
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
            benchReviewViewModel.getAverageRating()
        }
    }
}
