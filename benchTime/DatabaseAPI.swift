//
//  DatabaseAPI.swift
//  benchTime
//
//  Created by Joanna Xue on 15/5/2024.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

final class DatabaseAPI {
    static let shared = DatabaseAPI()
    private let database = Database.database(url: "https://benchtime-c265b-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
    
    private let users = "users"
    private let reviews = "reviews"
}

extension DatabaseAPI {
    func createUser(user: UserModel, completion: @escaping (Error?) -> Void) {
        print("Creating user with id:", user.uid, "...")
        let userRef = database.child(users).child(user.uid)
        userRef.setValue(user.toDictionary()) { error, _ in
            completion(error)
        }
        print("User added")
        print(user.toDictionary())
    }
    
    func readUser(uid: String, completion: @escaping (UserModel?, Error?) -> Void) {
        print("Reading user with id:", uid)
        if uid.isEmpty {
            completion(nil, NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "UID must not be empty."]))
        }
            
        let userRef = database.child(users).child(uid)

        userRef.observeSingleEvent(of: .value, with: { snapshot in
            // Check if the user data exists
            guard let userData = snapshot.value as? [String: Any] else {
                // If user data does not exist, complete with an error
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"]))
                return
            }

            // Initialize UserModel from snapshot data
            let user = UserModel(uid: uid,
                                 email: userData["email"] as? String ?? "",
                                 displayName: userData["displayName"] as? String ?? "",
                                 profileImageURL: userData["profileImageURL"] as? String ?? "")
            
            // Complete with the UserModel object and no error
            completion(user, nil)
        })
    }
    
    func updateUser(uid: String, newData: UserModel, oldData: UserModel, completion: @escaping (Error?) -> Void) {
        print("Updating user with id:", uid)
        if uid.isEmpty {
            completion(NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "UID must not be empty."]))
        }
        
        for (key, value) in newData.toDictionary() {
            if (value as! String != ""){
                print("Updating", key, "to", value ?? "default value")
                if (key == "profileImageURL" && oldData.profileImageURL != "") {
                    deleteImageFromStorage(imageURL: oldData.profileImageURL) { error in
                        if let error = error {
                            print("Failed to delete old profile picture \(oldData.profileImageURL): \(error.localizedDescription)")
                            completion(error)
                        }
                    }
                }
                database.child(users).child(uid).child(key).setValue(value) { error, _ in
                    if let error = error {
                        print("Failed to update field \(key): \(error.localizedDescription)")
                        completion(error)
                    }
                }
            }
        }
        AuthenticationManager.shared.fetchUserDetails()
        completion(nil)
    }
    
    func deleteUserAsync(uid: String) async throws {
        print("Attempting to delete user with UID: \(uid)")

        if uid.isEmpty {
            throw NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "UID must not be empty."])
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            database.child(users).child(uid).removeValue { error, _ in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: ())
                }
            }
        }
    }
    
    func deleteImageFromStorage(imageURL: String, completion: @escaping (Error?) -> Void) {
        // Create a reference to the image file
        let storageRef = Storage.storage().reference(forURL: imageURL)

        // Delete the file
        storageRef.delete { error in
            if let error = error {
                // Handle any errors
                print("Error deleting image: \(error.localizedDescription)")
                completion(error)
            } else {
                // Image deleted successfully
                print("Image deleted successfully")
                completion(nil)
            }
        }
    }
    
    func createReview(review: ReviewModel, completion: @escaping (Error?) -> Void) {
        print("Creating review for user with id:", review.uid ?? "", "...")
        let reviewRef = database.child(reviews).childByAutoId()
        let reviewID = reviewRef.key
        
        // Update the review ID in the ReviewModel
        var updatedReview = review
        updatedReview.id = reviewID!
        
        reviewRef.setValue(updatedReview.toDictionary()) { error, _ in
            completion(error)
        }
        print("Review added")
        print(review.toDictionary())
    }
    
    func readAllReviews(uid: String, completion: @escaping ([ReviewModel]?, Error?) -> Void) {
        print("Reading all reviews (except current user's)...")
        
        let reviewRef = database.child("reviews")  // Reference to the "reviews" node

        reviewRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let reviewDict = snapshot.value as? [String: Any] else {
                // If no review data found, complete with an empty array
                completion([], nil)
                return
            }

            // Parse reviews
            var reviews: [ReviewModel] = reviewDict.compactMap { (key, value) -> ReviewModel? in
                guard let reviewData = value as? [String: Any],
                      let reviewUID = reviewData["uid"] as? String,
                      reviewUID != uid else {
                    return nil // Skip reviews belonging to the specified user
                }
                
                // Parse review data and return a ReviewModel instance
                return ReviewModel(id: key,
                                   uid: reviewUID,
                                   title: reviewData["title"] as? String ?? "",
                                   description: reviewData["description"] as? String ?? "",
                                   rating: reviewData["rating"] as? Double ?? 0,
                                   imageURLs: reviewData["imageURLs"] as? [String] ?? [],
                                   createdTimestamp: reviewData["createdTimestamp"] as? String ?? "",
                                   updatedTimestamp: reviewData["updatedTimestamp"] as? String ?? ""
                                )
            }
            
            // Sort reviews by createdTimestamp
            reviews.sort(by: compareReviewsByDate)
            
            completion(reviews, nil)
        }) { error in
            // Handle Firebase error
            completion(nil, error)
        }
    }

    func readReviewsByUser(uid: String, completion: @escaping ([ReviewModel]?, Error?) -> Void) {
        print("Reading reviews from user:", uid)
        
        if uid.isEmpty {
            completion(nil, NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "UID must not be empty."]))
            return
        }
        
        let reviewRef = database.child("reviews")  // Reference to the "reviews" node

        reviewRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let reviewDict = snapshot.value as? [String: Any] else {
                // If no review data found, complete with an empty array
                completion([], nil)
                return
            }

            // Filter reviews by user ID
            var reviews: [ReviewModel] = reviewDict.compactMap { (key, value) -> ReviewModel? in
                guard let reviewData = value as? [String: Any],
                      let reviewUID = reviewData["uid"] as? String,
                      reviewUID == uid else {
                    return nil // Skip reviews not belonging to the specified user
                }
                
                // Parse review data and return a ReviewModel instance
                return ReviewModel(id: key,
                                   uid: reviewUID,
                                   title: reviewData["title"] as? String ?? "",
                                   description: reviewData["description"] as? String ?? "",
                                   rating: reviewData["rating"] as? Double ?? 0,
                                   imageURLs: reviewData["imageURLs"] as? [String] ?? [],
                                   createdTimestamp: reviewData["createdTimestamp"] as? String ?? "",
                                   updatedTimestamp: reviewData["updatedTimestamp"] as? String ?? ""
                                )
            }
            // Sort reviews by createdTimestamp
            reviews.sort(by: compareReviewsByDate)
            
            for review in reviews {
                print("Review \(review.title) - Created: \(review.createdTimestamp)")
            }
            
            completion(reviews, nil)
        }) { error in
            // Handle Firebase error
            completion(nil, error)
        }
    }

    func readReviewsByLocation(uid: String, completion: @escaping (Error?) -> Void) {
    }

    func readReviewByID(id: String, completion: @escaping (ReviewModel?, Error?) -> Void) {
        print("Reading review with id:", id)
        
        if id.isEmpty {
            completion(nil, NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "ID must not be empty."]))
        }
        
        let reviewRef = database.child(reviews).child(id)

        reviewRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let reviewData = snapshot.value as? [String: Any] else {
                // If review data does not exist, complete with an error
                completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Review data not found"]))
                return
            }
            
            let review = ReviewModel(id: id,
                                     uid: reviewData["uid"] as? String ?? "",
                                     title: reviewData["title"] as? String ?? "",
                                     description: reviewData["description"] as? String ?? "",
                                     rating: reviewData["rating"] as? Double ?? 0,
                                     imageURLs: reviewData["imageURLs"] as? [String] ?? [],
                                     createdTimestamp: reviewData["createdTimestamp"] as? String ?? "",
                                     updatedTimestamp: reviewData["updatedTimestamp"] as? String ?? ""
                                  )
            
            completion(review, nil)
        })
    }
    
    func deleteReview(id: String, completion: @escaping (Error?) -> Void) async throws {
        print("Attempting to delete review with ID: \(id)")

        if id.isEmpty {
            completion(NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "ID must not be empty."]))
            return
        }
        
        let reviewRef = database.child(reviews).child(id)
        
        // Retrieve imageURLs
        reviewRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let reviewData = snapshot.value as? [String: Any] else {
                // If review data does not exist, complete with an error
                completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Review data not found"]))
                return
            }
            let imageURLs = reviewData["imageURLs"] as? [String] ?? []
            
            // Delete images
            var deletionErrors: [Error] = []
            let dispatchGroup = DispatchGroup()
            for url in imageURLs {
                dispatchGroup.enter()
                self.deleteImageFromStorage(imageURL: url) { error in
                    if let error = error {
                        print("Failed to delete review picture \(url): \(error.localizedDescription)")
                        deletionErrors.append(error)
                    }
                    dispatchGroup.leave()
                }
            }
            
            // Wait for all deletions to finish
            dispatchGroup.notify(queue: .main) {
                if !deletionErrors.isEmpty {
                    completion(deletionErrors.first) // Return the first deletion error
                } else {
                    // All images deleted, now remove the review
                    reviewRef.removeValue { error, _ in
                        if let error = error {
                            completion(error)
                        } else {
                            completion(nil)
                        }
                    }
                }
            }
        })
    }
    
    func updateReview(id: String, newData: ReviewModel, completion: @escaping (Error?) -> Void) {
        print("Updating review with id:", id)
        
        if id.isEmpty {
            completion(NSError(domain: "BenchTime", code: 1002, userInfo: [NSLocalizedDescriptionKey: "ID must not be empty."]))
        }
        
        for (key, value) in newData.toDictionary() {
            if let stringValue = value as? String, !stringValue.isEmpty {
                print("Updating", key, "to", stringValue, "previous value:")
                // don't update photos... for now
                database.child(reviews).child(id).child(key).setValue(stringValue) { error, _ in
                    if let error = error {
                        print("Failed to update field \(key): \(error.localizedDescription)")
                        completion(error)
                    }
                }
            } else if let doubleValue = value as? Double {
                print("Updating", key, "to", doubleValue, "previous value:")
                // don't update photos... for now
                database.child(reviews).child(id).child(key).setValue(doubleValue) { error, _ in
                    if let error = error {
                        print("Failed to update field \(key): \(error.localizedDescription)")
                        completion(error)
                    }
                }
            }
        }
        completion(nil)
    }
}
