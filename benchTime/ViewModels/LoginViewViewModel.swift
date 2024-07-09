//
//  LoginViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 7/5/2024.
//

import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isLoading = false
    @Published var showAlert: Bool = false
      
    func login(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        self.isLoading = true
        
        if (email.isEmpty || password.isEmpty) {
            self.errorMessage = "Please fill in all fields"
            self.showAlert = true
            self.isLoading = false
            completion(.failure(.invalidDetails))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if (error != nil) {
                // Handle login error
                self.isLoading = false
                self.errorMessage = "Details not found"
                self.showAlert = true
                completion(.failure(.detailsNotFound))
            } else {
                // Login successful
                self.showAlert = false
                self.isLoading = false
                completion(.success(()))
            }
        }
    }
}
