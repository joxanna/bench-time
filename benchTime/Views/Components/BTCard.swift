//
//  BTCard.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import SwiftUI
import URLImage

struct BTCard: View {
    @EnvironmentObject private var rootViewModel: RootViewViewModel 
    
    @StateObject private var viewModel: BTCardViewModel
    
    let currentUser: Bool
    let address: Bool
        
    init(review: ReviewModel, currentUser: Bool, address: Bool, onUpdate: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: BTCardViewModel(review: review, onUpdate: onUpdate))
        self.currentUser = currentUser
        self.address = address
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 20.0) {
                HStack {
                    if let user = viewModel.user {
                        // Display user details
                        if user.profileImageURL != "" {
                            AsyncImage(url: URL(string: user.profileImageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 24, height: 24)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image("no-profile-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                        }
                        Spacer()
                            .frame(width: 8)
                        
                        Text("\(user.displayName)")
                            .font(.subheadline)
                            .foregroundStyle(Color.black)
                            .bold()
                    }
                }
                // only 1 image for now
                AsyncImage(url: URL(string: viewModel.review.imageURLs![0])) { image in
                    image
                        .resizable()
                        .clipped()
                        .cornerRadius(15)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .aspectRatio(1, contentMode: .fit)
                } placeholder: {
                    ProgressView()
                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.width)
                        .aspectRatio(1, contentMode: .fit)
                }
                
                
                HStack{
                    Text(viewModel.review.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                    Spacer()
                    VStack(alignment: .trailing) {
                        BTStars(rating: viewModel.review.rating)
                        Text(viewModel.ratingText)
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                
                Text(viewModel.review.description)
                    .foregroundStyle(Color.black)
                
                if (address) {
                    if (viewModel.addressText.isEmpty) {
                        Text("No address")
                            .foregroundColor(.gray)
                            .font(.system(size: 14))
                    } else {
                        Button(action: {
                            rootViewModel.openSearchBenchesView(address: viewModel.addressText, benchId: viewModel.review.benchId ?? "")
                        }) {
                            Text("📍 \(viewModel.addressText)")
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                HStack {
                    if (!viewModel.review.updatedTimestamp.isEmpty) {
                        Text("Updated on: \(viewModel.review.updatedTimestamp)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    } else {
                        Text("Posted on: \(viewModel.review.createdTimestamp)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                    }

                    Spacer()
                    if (currentUser) {
                        NavigationLink(destination: UpdateReviewView(review: viewModel.review, onDismiss: viewModel.onUpdate)) {
                            ZStack {
                                Circle()
                                    .fill(UIStyles.Colors.lightGray)
                                    .frame(width: 30, height: 30)

                                Image(systemName: "pencil")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            viewModel.isConfirmingAction.toggle()
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
            .background(
                Rectangle().foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.3), radius: 6)
            )
            .alert(isPresented: $viewModel.isConfirmingAction) {
                Alert(
                    title: Text("Delete review"),
                    message: Text("Are you sure you want to delete this review?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteReview()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            if (viewModel.isLoading) {
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 72, height: 72)
                        .cornerRadius(15)
                    ProgressView()
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}
