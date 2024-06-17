//
//  UpdatePasswordView.swift
//  benchTime
//
//  Created by Joanna Xue on 17/5/2024.
//

import SwiftUI
import FirebaseAuth

struct UpdateAccountDetailsView: View {
    @StateObject var viewModel = UpdateAccountDetailsViewViewModel()
    
    @StateObject var imageUploaderViewModel = ImageUploaderViewModel(storage: "profile_images")

    
    var body: some View {
        ZStack {
            VStack {
                TextField(viewModel.displayName, text: $viewModel.displayName, onCommit: {
                    hideKeyboard()
                })
                    .formFieldViewModifier()
                
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
                    
                    Button("Select Image") {
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
                
                BTButton(title: "Save profile", backgroundColor: (viewModel.isEmpty() ? Color.gray : Color.cyan)) {
                    viewModel.updateUser() { error in
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            print("Review created successfully")
                        }
                    }
                }
                .disabled(viewModel.isEmpty())
            }
            .padding(25)
            .navigationBarTitle("Account Details")
        }
    }
    
    private func handleImageUpload() async {
        await imageUploaderViewModel.uploadImage()
        print("finished:", imageUploaderViewModel.imageURL?.absoluteString ?? "")
        if let newImageURL = imageUploaderViewModel.imageURL?.absoluteString {
            viewModel.profileImageURL = newImageURL
        }
    }
}

