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
                Text("New review")
                    .bold()
                Spacer()
            }
            .padding()
            
            ScrollView {
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
                                                .foregroundColor(.cyan)
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
                                                .fill(UIStyles.Colors.lightGray)
                                                .frame(width: 44, height: 44)
                                            
                                            Image(systemName: "pencil")
                                                .foregroundColor(.gray)
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
                            .frame(height: 24)
                        
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
                    
                    if (isLoadingImagePicker) {
                        Loading()
                    }
                }
                .padding()
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
