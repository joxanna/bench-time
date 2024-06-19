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
    @StateObject var viewModel: NewReviewViewViewModel
    @State private var selectedRating: Double = 0
    let options = [0, 0.5, 1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5]

    @StateObject var imageUploaderViewModel = ImageUploaderViewModel(storage: "review_images")
    
    init(benchId: String, latitude: Double, longitude: Double) {
        _viewModel = StateObject(wrappedValue: NewReviewViewViewModel(benchId: benchId, latitude: latitude, longitude: longitude))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Title*")
                TextField("Enter a title", text: $viewModel.title, onCommit: {
                    hideKeyboard()
                })
                    .formFieldViewModifier()
                
                Text("Description*")
                TextEditor(text: $viewModel.description)
                    .formFieldViewModifier()
                    .frame(height: 200)

                Text("Rating*")
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
                
                
                VStack {
                    if let _ = imageUploaderViewModel.image, imageUploaderViewModel.imageURL == nil {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else if let image = imageUploaderViewModel.image, let _ = imageUploaderViewModel.imageURL {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("No Image Selected")
                    }
                    
                    Button("Select Image*") {
                        imageUploaderViewModel.isShowingImagePicker = true
                    }
                }
                .sheet(isPresented: $imageUploaderViewModel.isShowingImagePicker, onDismiss: {
                    Task {
                        await handleImageUpload()
                    }
                }){
                    ImagePicker(image: $imageUploaderViewModel.image)
                }
                
                BTButton(title: "Submit review", backgroundColor: (viewModel.isEmpty() ? Color.gray : Color.cyan)) {
                    viewModel.createReview() { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            imageUploaderViewModel.reset()
                            print("Review created successfully")
                        }
                    }
                }
                .disabled(viewModel.isEmpty())
            }
            .padding()
        }
    }
    
    private func handleImageUpload() async {
        await imageUploaderViewModel.uploadImage()
        if let newImageURL = imageUploaderViewModel.imageURL?.absoluteString {
            viewModel.imageURLs.append(newImageURL)
        }
    }
}
