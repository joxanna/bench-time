//
//  UserModel.swift
//  benchTime
//
//  Created by Joanna Xue on 11/5/2024.
//

import Foundation

struct UserModel {
    var uid: String
    var email: String
    var displayName: String
    var profileImageURL: String
    
    init(uid: String, email: String, displayName: String, profileImageURL: String) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
        self.profileImageURL = profileImageURL
    }
    
    func toDictionary() -> [String: Any?] {
        return [
            "uid": uid,
            "email": email,
            "displayName": displayName,
            "profileImageURL": profileImageURL
        ]
    }
}
