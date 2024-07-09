//
//  ImageUploaderViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import Foundation
import FirebaseStorage
import SwiftUI

class ImageUploaderViewModel: ObservableObject {
    @Published var imageURL: URL?
    @Published var image: UIImage?
    @Published var isShowingImagePicker = false
    @Published var isLoading = false
    
    private let imageUploader = ImageUploader()
    private let storage: String

    init(storage: String) {
        self.storage = storage
    }
    
    func uploadImage() async {
        guard let image = image else { return }
        
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let url = try await imageUploader.uploadImageToStorage(image: image, child: storage)
            DispatchQueue.main.async {
                self.imageURL = url
                self.isLoading = false
            }
            print("Image uploaded successfully: \(url)")
        } catch {
            // Handle error
            DispatchQueue.main.async {
                // If you want to update any state related to the error
                self.isLoading = false
            }
            print("Error uploading image:", error.localizedDescription)
        }
    }
    
    func reset() {
        imageURL = nil
        image = nil
    }
    
    func selectNewImage() {
        if let imageURL = imageURL {
            DatabaseAPI.shared.deleteImageFromStorage(imageURL: imageURL.absoluteString) { error in
                if let error = error {
                    print("\(error.localizedDescription)")
                } else {
                    print("Image deleted")
                }
            }
        }
        reset()
    }
}
