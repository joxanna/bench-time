//
//  GlobalFunctions.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

import Foundation
import SwiftUI

func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

func compareReviewsByDate(review1: ReviewModel, review2: ReviewModel) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    guard let date1 = dateFormatter.date(from: review1.createdTimestamp),
          let date2 = dateFormatter.date(from: review2.createdTimestamp) else {
        return false
    }
    return date1 > date2
}
