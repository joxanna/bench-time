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
    
    init() {}
    
    func register(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        guard !displayName.trimmingCharacters(in: .whitespaces).isEmpty, !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            completion(.failure(AuthenticationError.invalidDetails))
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Registration failed
                completion(.failure(AuthenticationError.registrationFailed(error)))
            } else if let authResult = authResult {
                // Registration successful
                let uid = authResult.user.uid
                let userData = UserModel(uid: uid, email: self.email, displayName: self.displayName, profileImageURL: "")
                DatabaseAPI.shared.createUser(user: userData){ error in
                    if let error = error {
                        // Error saving user data to database
                        completion(.failure(AuthenticationError.registrationFailed(error)))
                    } else {
                        // User data saved successfully
                        completion(.success(()))
                    }
                }
            }
            
        }
    }
}
