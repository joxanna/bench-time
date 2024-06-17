//
//  UpdateAccountDetailsViewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import Foundation
import SwiftUI

class UpdateAccountDetailsViewViewModel: ObservableObject {
    @Published var uid: String
    @Published var displayName: String
    @Published var profileImageURL: String

    private var currentUserDetails = AuthenticationManager.shared.currentUserDetails
    
    init () {
        uid = currentUserDetails?.uid ?? ""
        displayName = currentUserDetails?.displayName ?? ""
        profileImageURL = currentUserDetails?.profileImageURL ?? ""
    }
    
    func updateUser(completion: @escaping (Error?) -> Void) {
        let newData = UserModel(uid: uid, email: "", displayName: displayName, profileImageURL: profileImageURL)
        
        DatabaseAPI.shared.updateUser(uid: uid, newData: newData, oldData: AuthenticationManager.shared.currentUserDetails!) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("User updated successfully")
            }
        }
    }
    
    func isEmpty() -> Bool {
        if displayName == currentUserDetails?.displayName || profileImageURL == currentUserDetails?.profileImageURL {
            return true
        }
        return false
    }
}
