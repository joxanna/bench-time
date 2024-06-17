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
    
    init() {}
      
    func login(completion: @escaping (Result<Void, AuthenticationError>) -> Void) {
        if (email.isEmpty || password.isEmpty) {
            completion(.failure(.invalidDetails))
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if (error != nil) {
                // Handle login error
                completion(.failure(.detailsNotFound))
            } else {
                // Login successful
                completion(.success(()))
            }
        }
    }
}
