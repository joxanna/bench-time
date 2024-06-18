//
//  ReviewViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 18/6/2024.
//

import Foundation

protocol ReviewViewModel: AnyObject {
    func didUpdateAddress(for review: ReviewModel, address: String)
}

