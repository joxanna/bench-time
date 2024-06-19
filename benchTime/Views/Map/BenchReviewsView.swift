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
    @State private var addressText: String = "No address"
    
    @ObservedObject var authManager = AuthenticationManager.shared
    @State private var benchReviews: [ReviewModel]?
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("ID: \(String(bench.id))")
                Text(addressText)
                
                NavigationLink {
                    NewReviewView(benchId: String(bench.id), latitude: benchAnnotation.coordinate.latitude, longitude: benchAnnotation.coordinate.longitude)
                } label: {
                    Text("New Review")
                        .foregroundColor(.cyan)
                        .font(.headline)
                }
                
                VStack {
                    if let reviews = benchReviews {
                        ForEach(reviews) { review in
                            BTCard(review: review, currentUser: (review.uid == authManager.currentUser?.uid), address: false) {
                                fetchReviews()
                            }
                        }
                    } else {
                        ProgressView() // Show loading indicator while reviews are being fetched
                    }
                }
            }
        }
        .onAppear {
            getAddress(latitude: benchAnnotation.coordinate.latitude, longitude: benchAnnotation.coordinate.longitude) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                else if let result = result {
                    self.addressText = result
                }
            }
            
            fetchReviews()
        }
    }
    
    func fetchReviews() {
        print("Fetching...")
        guard let uid = authManager.currentUser?.uid else {
            print("UID issue")
            return
        }
        
        DatabaseAPI.shared.readReviewsByBench(benchId: String(bench.id)) { reviews, error in
            if let error = error {
                // Handle the error
                self.errorMessage = error.localizedDescription
                print("Fail")
            } else if let reviews = reviews {
                // Assign currentUserReviews here
                self.benchReviews = reviews
                print("Success")
            }
        }
    }
}
