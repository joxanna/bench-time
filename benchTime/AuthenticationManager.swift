//
//  AuthenticationManager.swift
//  benchTime
//
//  Created by Joanna Xue on 9/5/2024.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
    }
}

enum AuthenticationError: Error {
    case invalidDetails
    case detailsNotFound
    case registrationFailed(Error)
}

class AuthenticationManager : ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var showSignInView: Bool = false;
    @Published var currentUser: User?
    @Published var currentUserDetails: UserModel?
    
    private init() {
        Auth.auth().addStateDidChangeListener{[weak self] _, user in
            self?.handleAuthStateChange(user: user)
        }
        
        assignCurrentUser()
    }
    
    private func handleAuthStateChange(user: User?) {
        print("Handling state change...")
        self.currentUser = user
        self.showSignInView = user == nil
        if user != nil {
            self.fetchUserDetails()
        } else {
            self.currentUserDetails = nil
        }
    }
    
    func fetchUserDetails() {
        let uid = self.currentUser?.uid ?? ""
        
        if (uid.isEmpty) {
            return
        }
        
        DatabaseAPI.shared.readUser(uid: uid) { userDetails, error in
            if error != nil {
                print("Read error")
            } else {
                self.currentUserDetails = userDetails
            }
        }
    }
    
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Error?) -> Void) {
        print("Updating password...")
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(NSError(domain: "BenchTime", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"]))
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        user.reauthenticate(with: credential) { authResult, error in
            if let error = error {
                completion(error) // Error during reauthentication
                return
            }
            
            // Reauthentication successful, update password
            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(error) // Error updating password
                } else {
                    completion(nil) // Password updated successfully
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            checkCurrentUser()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    private func assignCurrentUser() {
        if let user = Auth.auth().currentUser {
            handleAuthStateChange(user: user)
        } else {
            handleAuthStateChange(user: nil)
        }
    }
    
    private func checkCurrentUser() {
        let user = Auth.auth().currentUser
        self.showSignInView = user == nil
    }
    
    func deleteCurrentUserAsync() async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "BenchTime", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."])
        }

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            user.delete { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
}
