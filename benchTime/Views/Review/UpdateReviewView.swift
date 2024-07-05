//
//  UpdateReviewView.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import SwiftUI

struct UpdateReviewView: View {
    let review: ReviewModel
    @StateObject var viewModel = UpdateReviewViewViewModel()
    
    @State private var selectedRating: Double = 0
    let options = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                BTFormField(label: "Title", text:  $viewModel.title)
                
                BTTextEditor(label: "Description", text: $viewModel.description)

                Text("Rating")
                HStack {
                    BTStars(rating: selectedRating)
                    Spacer()
                    Picker("Rating", selection: $selectedRating) {
                        ForEach(options, id: \.self) { option in
                            Text(String(option)).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedRating) { _, newRating in
                        viewModel.rating = newRating
                    }
                }
                
                BTButton(title: "Save", backgroundColor: Color.cyan) {
                    viewModel.updateReview(id: review.id!) { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Review updated successfully")
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear() {
            viewModel.title = review.title
            viewModel.description = review.description
            selectedRating = review.rating
        }
    }
}
