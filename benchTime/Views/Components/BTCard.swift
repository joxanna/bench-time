//
//  BTCard.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI
import URLImage

struct BTCard: View {    
    let review: ReviewModel
    let currentUser: Bool
    let address: Bool
    var onUpdate: () -> Void
    
    @State private var isLargeModalPresented = false
    @State private var isConfirmingAction = false
    
    @State private var ratingText: String = ""
    @State private var addressText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20.0) {
            // only 1 image for now
            AsyncImage(url: URL(string: review.imageURLs![0])) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
            } placeholder: {
                ProgressView()
            }
            
            HStack{
                Text(review.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.black)
                Spacer()
                VStack(alignment: .trailing) {
                    BTStars(rating: review.rating)
                    Text(ratingText)
                        .foregroundColor(.orange)
                        .font(.caption)
                }
            }
            
            Text(review.description)
                .foregroundStyle(Color.black)
            
            if (address) {
                if (addressText.isEmpty) {
                    Text("No address")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                } else {
                    Text(addressText)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
            }
            
            HStack {
                if (!review.updatedTimestamp.isEmpty) {
                    Text("Updated on: \(review.updatedTimestamp)")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                } else {
                    Text("Posted on: \(review.createdTimestamp)")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }

                Spacer()
                if (currentUser) {
                    Button(action: {
                        isLargeModalPresented.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(UIStyles.Colors.lightGray)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                                .font(.system(size: 16))
                        }
                    }
                    
                    Button(action: {
                        isConfirmingAction.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .fill(UIStyles.Colors.lightGray)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "trash.fill")
                                .foregroundColor(UIStyles.Colors.red)
                                .font(.system(size: 16))
                        }
                    }
                }
            }
        }
        .padding()
        .background(Rectangle().foregroundColor(.white)
            .cornerRadius(15)
            .shadow(radius: 15))
        .padding()
        .sheet(isPresented: $isLargeModalPresented) {
            LargeModalView(title: "Update review", contentView: UpdateReviewView(review: review)) 
//            {
//                onUpdate()
//                print("Refreshing...")
//            }
        }
        .alert(isPresented: $isConfirmingAction) {
            Alert(
                title: Text("Confirm Action"),
                message: Text("Are you sure you want to delete this item?"),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        try await DatabaseAPI.shared.deleteReview(id: review.id!) { error in
                            if let error = error {
                                print("Deleting failed: \(error.localizedDescription)")
                            } else {
                                print("Delete successful")
                                onUpdate()
                                print("Refreshing...")
                            }
                        }
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            if review.rating.truncatingRemainder(dividingBy: 1) == 0 {
                // Rating is a whole number, display it as an integer
                self.ratingText = String(format: "(%.0f/5 stars)", review.rating)
            } else {
                // Rating has a decimal part, display it with one decimal place
                self.ratingText = String(format: "(%.1f/5 stars)", review.rating)
            }
            
            if (address) {
                getAddress(latitude: review.latitude, longitude: review.longitude) { result, error in
                    if let error = error {
                        print(error.localizedDescription)
                        self.addressText = "No address"
                    }
                    else if let result = result {
                        self.addressText = result
                    }
                }
            }
        }
    }
}
