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
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var sheetStateManager: SheetStateManager
    @EnvironmentObject private var rootViewModel: RootViewViewModel

    @StateObject var viewModel: NewReviewViewViewModel
    var onDismiss: () -> Void

    @StateObject var imageUploaderViewModel = ImageUploaderViewModel(storage: "review_images")

    init(benchId: String, latitude: Double, longitude: Double, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: NewReviewViewViewModel(benchId: benchId, latitude: latitude, longitude: longitude))
        self.onDismiss = onDismiss
    }
    
    @State private var showAlert: Bool = false
    @State private var isLoadingImagePicker: Bool = false

    var body: some View {
        VStack {
            ZStack {
                Text("New review")
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
                                .font(.system(size: 20, weight: .medium))
                            Text("Back")
                        }
                    }
                    Spacer()
                }
                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
            }
            .padding(10)
            
            ScrollView(showsIndicators: false) {
                ZStack {
                    VStack(alignment: .leading) {
                        BTFormField(label: "Title*", text:  $viewModel.title)
                        
                        BTTextEditor(label: "Description*", text: $viewModel.description)
                        
                        Text("Rating*")
                            .font(.caption)
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                        BTRating(rating: $viewModel.rating)
                            .padding(.bottom, 16)
                        
                        Text("Image*")
                            .font(.caption)
                            .padding(.top, 8)
                            .padding(.bottom, 4)
                        
                        VStack {
                            if let _ = imageUploaderViewModel.image, imageUploaderViewModel.imageURL == nil {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                    Spacer()
                                }
                            } else {
                                if (imageUploaderViewModel.imageURL == nil && !imageUploaderViewModel.isLoading) {
                                    Button(action: {
                                        isLoadingImagePicker = true
                                        imageUploaderViewModel.isShowingImagePicker = true
                                        imageUploaderViewModel.selectNewImage()
                                    }) {
                                        HStack {
                                            Spacer()
                                            Image(systemName: "photo.badge.plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 44, height: 44)
                                                .foregroundColor(colorScheme == .dark ? UIStyles.Colors.Dark.link : UIStyles.Colors.Light.link)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                            
                            ZStack(alignment: .topTrailing) {
                                if let image = imageUploaderViewModel.image, let _ = imageUploaderViewModel.imageURL {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: UIScreen.main.bounds.width)
                                        .clipped()
                                        .frame(alignment: .center)
                                        .cornerRadius(15)
                                }
                                
                                if (imageUploaderViewModel.imageURL != nil) {
                                    Button(action: {
                                        imageUploaderViewModel.isShowingImagePicker = true
                                        imageUploaderViewModel.selectNewImage()
                                    }) {
                                        ZStack {
                                            Circle()
                                                .fill(colorScheme == .dark ? UIStyles.Colors.darkGray : UIStyles.Colors.lightGray)
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "pencil")
                                                .foregroundColor(UIStyles.Colors.gray)
                                                .font(.system(size: 24))
                                                .bold()
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .padding(10)
                                }
                            }
                        }
                        .sheet(isPresented: $imageUploaderViewModel.isShowingImagePicker, onDismiss: {
                            Task {
                                await handleImageUpload()
                            }
                        }){
                            ImagePicker(image: $imageUploaderViewModel.image)
                                .onAppear {
                                    isLoadingImagePicker = false
                                }
                        }
                        
                        Spacer()
                            .frame(height: 20)
                        
                        BTButton(title: "Post", isDisabled: viewModel.isEmpty()) {
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
                            .frame(height: 20)
                    }
                    
                    if (isLoadingImagePicker) {
                        Loading()
                    }
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text("Do you want to discard changes?"),
                primaryButton: .destructive(Text("Discard")) {
                    viewModel.clear()
                    onClose()
                },
                secondaryButton: .cancel()
            )
        }
        .onDisappear {
            onDismiss()
        }
    }
    
    private func onClose() {
        presentationMode.wrappedValue.dismiss()
        onDismiss()
    }
    
    private func handleImageUpload() async {
        await imageUploaderViewModel.uploadImage()
        if let newImageURL = imageUploaderViewModel.imageURL?.absoluteString {
            viewModel.imageURLs = [newImageURL]
        }
    }
}
