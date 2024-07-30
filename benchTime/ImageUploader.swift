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
import CropViewController

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
    var cropStyle: CropViewCroppingStyle = .default // Add a cropping style property

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, cropStyle: cropStyle)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
        let parent: ImagePicker
        var cropStyle: CropViewCroppingStyle

        init(parent: ImagePicker, cropStyle: CropViewCroppingStyle) {
            self.parent = parent
            self.cropStyle = cropStyle
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                let cropViewController = CropViewController(croppingStyle: cropStyle, image: uiImage)
                cropViewController.delegate = self
                cropViewController.aspectRatioPreset = .presetSquare // Set aspect ratio preset to square
                cropViewController.aspectRatioLockEnabled = true // Lock the aspect ratio
                picker.present(cropViewController, animated: true, completion: nil)
            }
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.image = image
            cropViewController.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func cropViewControllerDidCancel(_ cropViewController: CropViewController) {
            cropViewController.dismiss(animated: true) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
