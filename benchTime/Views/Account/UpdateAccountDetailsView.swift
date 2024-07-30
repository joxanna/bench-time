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
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = UpdateAccountDetailsViewViewModel()
    @StateObject var imageUploaderViewModel = ImageUploaderViewModel(storage: "profile_images")
    
    @State private var showAlert: Bool = false
    @State private var isUpdating: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 32)
                VStack {
                    if let _ = imageUploaderViewModel.image, imageUploaderViewModel.imageURL == nil {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .frame(width: 64, height: 64)
                    } else if let image = imageUploaderViewModel.image, let _ = imageUploaderViewModel.imageURL {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                    } else {
                        if viewModel.profileImageURL != "" {
                            AsyncImage(url: URL(string: viewModel.profileImageURL)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 64, height: 64)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 64, height: 64)
                            }
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
                        imageUploaderViewModel.selectNewImage()
                    }) {
                        Text("Edit profile picture")
                            .foregroundColor(imageUploaderViewModel.isLoading ? UIStyles.Colors.disabled : (colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link))
                            .bold()
                    }
                    .disabled(imageUploaderViewModel.isLoading)
                }
                .sheet(isPresented: $imageUploaderViewModel.isShowingImagePicker, onDismiss: {
                    Task {
                        await handleImageUpload()
                    }
                }){
                    ImagePicker(image: $imageUploaderViewModel.image, cropStyle: .circular) 
                }
                Spacer()
                    .frame(height: 24)
                
                BTFormField(label: "Display name", text:  $viewModel.displayName)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height, alignment: .topLeading)
            
            if isUpdating {
                Loading()
            }
        }
        .navigationBarTitle("Update account details")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button(action: {
                        if !viewModel.isEmpty() {
                            showAlert = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                        }
                    }
                }
                .padding(.leading, -10)
                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if !viewModel.isEmpty() {
                    NavigationLink(destination: SettingsView()) {
                        Button(action: {
                            isUpdating = true
                            viewModel.updateUser() { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    isUpdating = false
                                } else {
                                    print("Account updated successfully")
                                    presentationMode.wrappedValue.dismiss()
                                    isUpdating = false
                                }
                            }
                        }) {
                            Text("Done")
                                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
                                .bold()
                        }
                        .transition(.opacity)
                    }
                }
            }
        }
        .animation(.default, value: viewModel.isEmpty())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to discard changes?"),
                primaryButton: .destructive(Text("Discard")) {
                    viewModel.clear()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .padding()
    }
    
    private func handleImageUpload() async {
        await imageUploaderViewModel.uploadImage()
        if let newImageURL = imageUploaderViewModel.imageURL?.absoluteString {
            viewModel.profileImageURL = newImageURL
        }
    }
}


