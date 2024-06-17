//
//  ReviewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 20/5/2024.
//

import Foundation

struct ReviewModel: Hashable, Identifiable {
    var id: String? = ""
    var uid: String?
    var title: String
    var description: String
    var rating: Double
    var imageURLs: [String]?
    var createdTimestamp: String = ""
    var updatedTimestamp: String = ""
    
    // hold data to create
    init(uid: String, title: String, description: String, rating: Double, imageURLs: [String]) {
        self.uid = uid
        self.title = title
        self.description = description
        self.rating = rating
        self.imageURLs = imageURLs
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        self.createdTimestamp = dateFormatter.string(from: currentDate)
    }
    
    // actual full review
    init(id: String, uid: String, title: String, description: String, rating: Double, imageURLs: [String], createdTimestamp: String, updatedTimestamp: String) {
        self.id = id
        self.uid = uid
        self.title = title
        self.description = description
        self.rating = rating
        self.imageURLs = imageURLs
        self.createdTimestamp = createdTimestamp
        self.updatedTimestamp = updatedTimestamp
    }
    
    // updateable
    init(title: String, description: String, rating: Double) {
        self.title = title
        self.description = description
        self.rating = rating
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        self.updatedTimestamp = dateFormatter.string(from: currentDate)
    }
    
    func toDictionary() -> [String: Any?] {
        return [
            "id": id,
            "uid": uid,
            "title": title,
            "description": description,
            "rating": rating,
            "imageURLs": imageURLs,
            "createdTimestamp": createdTimestamp,
            "updatedTimestamp": updatedTimestamp
            ]
    }
    
    func isEmpty() -> Bool {
        return title.isEmpty || description.isEmpty || imageURLs == [] || uid!.isEmpty
    }
    
    func hash(into hasher: inout Hasher) {
        // Implement custom hashing logic here, e.g., hash based on unique identifier
        hasher.combine(id)
    }

    static func == (lhs: ReviewModel, rhs: ReviewModel) -> Bool {
        // Implement equality comparison logic here, e.g., compare unique identifiers
        return lhs.id == rhs.id
    }
}
