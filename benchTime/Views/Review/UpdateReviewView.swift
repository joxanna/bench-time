//
//  UpdateReviewView.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import SwiftUI

struct UpdateReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let review: ReviewModel
    @StateObject var viewModel = UpdateReviewViewViewModel()
    var onDismiss: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                BTFormField(label: "Title", text:  $viewModel.title)
                
                BTTextEditor(label: "Description", text: $viewModel.description)

                Text("Rating")
                    .font(.caption)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                BTRating(rating: $viewModel.rating)
                    .padding(.bottom, 24)
               
                Spacer()
                
                BTButton(title: "Save", backgroundColor: (viewModel.isEmpty(review: review) ? Color.gray : Color.cyan)) {
                    viewModel.updateReview(id: review.id!) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Review updated successfully")
                            onDismiss() 
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .disabled(viewModel.isEmpty(review: review))
                
                Spacer()
                    .frame(height: 16)
            }
            .padding()
        }
        .onAppear() {
            viewModel.title = review.title
            viewModel.description = review.description
            viewModel.rating = review.rating
        }
        .navigationBarTitle("Edit review")
    }
}
