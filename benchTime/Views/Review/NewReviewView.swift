//
//  NewReviewView.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import SwiftUI
import FirebaseAuth
import SwiftOverpassAPI

struct NewReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: NewReviewViewViewModel
    var onDismiss: () -> Void

    @StateObject var imageUploaderViewModel = ImageUploaderViewModel(storage: "review_images")
    
    init(benchId: String, latitude: Double, longitude: Double, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: NewReviewViewViewModel(benchId: benchId, latitude: latitude, longitude: longitude))
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                BTFormField(label: "Title*", text:  $viewModel.title)
                
                BTTextEditor(label: "Description*", text: $viewModel.description)

                Text("Rating*")
                    .font(.caption)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                BTRating(rating: $viewModel.rating)
                    .padding(.bottom, 24)
                
                Text("Image*")
                    .font(.caption)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                VStack {
                    if let _ = imageUploaderViewModel.image, imageUploaderViewModel.imageURL == nil {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if let image = imageUploaderViewModel.image, let _ = imageUploaderViewModel.imageURL {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(alignment: .center)
                            .cornerRadius(15)
                    }
                    
                    
                    Button(action: {
                        imageUploaderViewModel.isShowingImagePicker = true
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 44, height: 44)
                            Spacer()
                        }
                    }
                }
                .sheet(isPresented: $imageUploaderViewModel.isShowingImagePicker, onDismiss: {
                    Task {
                        await handleImageUpload()
                    }
                }){
                    ImagePicker(image: $imageUploaderViewModel.image)
                }
                
                Spacer()
                
                BTButton(title: "Post", backgroundColor: (viewModel.isEmpty() ? Color.gray : Color.cyan)) {
                    viewModel.createReview() { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            imageUploaderViewModel.reset()
                            presentationMode.wrappedValue.dismiss()
                            onDismiss()
                            print("Review created successfully")
                        }
                    }
                }
                .disabled(viewModel.isEmpty())
                Spacer()
                    .frame(height: 16)
            }
            .padding()
        }
        .navigationBarTitle("New review")
    }
    
    private func handleImageUpload() async {
        await imageUploaderViewModel.uploadImage()
        if let newImageURL = imageUploaderViewModel.imageURL?.absoluteString {
            viewModel.imageURLs.append(newImageURL)
        }
    }
}
