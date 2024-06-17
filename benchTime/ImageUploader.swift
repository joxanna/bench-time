//
//  ImageUploader.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI

final class ImageUploader {
    static let shared = ImageUploader()
    
    func uploadImageToStorage(image: UIImage, child: String) async throws -> URL {
        print("Uploading to storage...")
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let storageRef = Storage.storage().reference().child(child).child(UUID().uuidString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        return try await withCheckedThrowingContinuation { continuation in
            storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    storageRef.downloadURL { (url, error) in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let downloadURL = url {
                            continuation.resume(returning: downloadURL)
                        }
                    }
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
