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
    
    var latitude: Double = Double.nan
    var longitude: Double = Double.nan
    
    // hold data to create
    init(uid: String, title: String, description: String, rating: Double, imageURLs: [String], latitude: Double, longitude: Double) {
        self.uid = uid
        self.title = title
        self.description = description
        self.rating = rating
        self.imageURLs = imageURLs
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        self.createdTimestamp = dateFormatter.string(from: currentDate)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // actual full review
    init(id: String, uid: String, title: String, description: String, rating: Double, imageURLs: [String], createdTimestamp: String, updatedTimestamp: String, latitude: Double, longitude: Double) {
        self.id = id
        self.uid = uid
        self.title = title
        self.description = description
        self.rating = rating
        self.imageURLs = imageURLs
        self.createdTimestamp = createdTimestamp
        self.updatedTimestamp = updatedTimestamp
        self.latitude = latitude
        self.longitude = longitude
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
            "updatedTimestamp": updatedTimestamp,
            "latitude": latitude,
            "longitude": longitude,
            ]
    }
    
    func isEmpty() -> Bool {
        guard let uid = uid, !uid.isEmpty else { return true }
        guard !title.isEmpty else { return true }
        guard !description.isEmpty else { return true }
        guard !(imageURLs?.isEmpty ?? true) else { return true }
        guard !latitude.isNaN else { return true }
        guard !longitude.isNaN else { return true }
        
        return false
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
