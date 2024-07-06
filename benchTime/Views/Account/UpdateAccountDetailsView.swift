//
//  UpdatePasswordView.swift
//  benchTime
//
//  Created by Joanna Xue on 17/5/2024.
//

import SwiftUI
import URLImage

struct UpdateAccountDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = UpdateAccountDetailsViewViewModel()
    @StateObject var imageUploaderViewModel = ImageUploaderViewModel(storage: "profile_images")

    var body: some View {
        VStack {
            Spacer()
                .frame(height: 32)
            VStack {
                if let _ = imageUploaderViewModel.image, imageUploaderViewModel.imageURL == nil {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let image = imageUploaderViewModel.image, let _ = imageUploaderViewModel.imageURL {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                } else {
                    if viewModel.profileImageURL != "" {
                        URLImage(URL(string: viewModel.profileImageURL)!) { image in
                           image
                               .resizable()
                               .aspectRatio(contentMode: .fill)
                       }
                       .frame(width: 64, height: 64)
                       .clipShape(Circle())
                    } else {
                        Image("no-profile-image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    imageUploaderViewModel.isShowingImagePicker = true
                    
                }) {
                    Text("Edit profile picture")
                        .foregroundColor(.cyan)
                        .bold()
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
                .frame(height: 24)
            
            BTFormField(label: "Display name", text:  $viewModel.displayName)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height, alignment: .topLeading)
        .navigationBarTitle("Update account details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isEmpty() {
                    NavigationLink(destination: SettingsView()) {
                        Button(action: {
                            viewModel.updateUser() { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                } else {
                                    print("Account updated successfully")
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }) {
                            Text("Done")
                                .foregroundColor(.cyan)
                                .bold()
                        }
                        .transition(.opacity)
                    }
                }
            }
        }
        .animation(.default, value: viewModel.isEmpty()) 
        .padding()
    }
    
    private func handleImageUpload() async {
        await imageUploaderViewModel.uploadImage()
        print("finished:", imageUploaderViewModel.imageURL?.absoluteString ?? "")
        if let newImageURL = imageUploaderViewModel.imageURL?.absoluteString {
            viewModel.profileImageURL = newImageURL
        }
    }
}

