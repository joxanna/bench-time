//
//  RegisterViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 9/5/2024.
//

import Foundation
import FirebaseAuth

class RegisterViewViewModel: ObservableObject {
    @Published var displayName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var showAlert: Bool = false
    
    func register(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        self.isLoading = true
        
        guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty, !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.errorMessage = "Please fill in all fields"
            self.showAlert = true
            self.isLoading = false
            completion(.failure(AuthenticationError.invalidDetails))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Registration failed
                self.isLoading = false
                self.errorMessage = "\(error.localizedDescription)"
                self.showAlert = true
                completion(.failure(AuthenticationError.registrationFailed(error)))
            } else if let authResult = authResult {
                // Registration successful
                let uid = authResult.user.uid
                let userData = UserModel(uid: uid, email: self.email, displayName: self.displayName, profileImageURL: "")
                DatabaseAPI.shared.createUser(user: userData){ error in
                    if let error = error {
                        // Error saving user data to database
                        self.errorMessage = "\(error.localizedDescription)"
                        self.showAlert = true
                        self.isLoading = false
                        completion(.failure(AuthenticationError.registrationFailed(error)))
                    } else {
                        // User data saved successfully
                        self.showAlert = false
                        self.isLoading = false
                        completion(.success(()))
                    }
                }
            }
            
        }
    }
}
