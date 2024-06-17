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
    
    private let imageUploader = ImageUploader()
    private let storage: String

    init(storage: String) {
        self.storage = storage
    }
    
    func uploadImage() async {
        guard let image = image else { return }
        
        do {
            let url = try await imageUploader.uploadImageToStorage(image: image, child: storage)
            DispatchQueue.main.async {
                self.imageURL = url
            }
            print("Image uploaded successfully: \(url)")
        } catch {
            // Handle error
            DispatchQueue.main.async {
                // If you want to update any state related to the error
                // self.errorMessage = error.localizedDescription
            }
            print("Error uploading image:", error.localizedDescription)
        }
    }
    
    func reset() {
        imageURL = nil
        image = nil
    }
}

