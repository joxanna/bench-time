//
//  UpdateReviewView.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import SwiftUI

struct UpdateReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: UpdateReviewViewViewModel
    var onDismiss: () -> Void
    
    init(review: ReviewModel, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: UpdateReviewViewViewModel(review: review))
        self.onDismiss = onDismiss
    }
    
    @State var showAlert: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Text("Update review")
                    .bold()
                
                HStack {
                    Button(action: {
                        if (viewModel.isNotEmpty()) {
                            showAlert = true
                        } else {
                            onClose()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 20)
            
            ScrollView(showsIndicators: false) {
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
                    
                    BTButton(title: "Save", backgroundColor: (viewModel.isEmpty() ? Color.gray : Color.cyan)) {
                        viewModel.updateReview() { error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Review updated successfully")
                                onDismiss()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isEmpty())
                }
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to discard changes?"),
                primaryButton: .destructive(Text("Discard")) {
                    onClose()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            viewModel.reset()
        }
        .onDisappear {
            onDismiss()
        }
    }
                          
    private func onClose() {
        viewModel.reset()
        presentationMode.wrappedValue.dismiss()
        onDismiss()
    }
}
