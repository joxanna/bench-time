//
//  UIStyles.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import Foundation
import SwiftUI

// Define a struct for global UI styles
struct UIStyles {
    
    // Define global colors
    struct Colors {
//        static let primaryColor = Color(hex: "#3498db")
//        static let secondaryColor = Color(hex: "#2ecc71")
//        static let backgroundColor = Color(hex: "#ecf0f1")
//        static let textColor = Color(hex: "#2c3e50")
        static let lightGray = Color(red: 0.89, green: 0.89, blue: 0.89)
        static let red = Color(red: 0.812, green: 0.259, blue: 0.259)
        static let theme = UIColor.blue
    }
    
    // Define global text styles
    struct TextStyles {
        static let title = Font.system(size: 24, weight: .bold, design: .default)
        static let body = Font.system(size: 16, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .light, design: .default)
    }
    
    struct Padding {
        static let xsmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xlarge: CGFloat = 20
        static let xxlarge: CGFloat = 24
        static let xxxlarge: CGFloat = 30
    }
    
    struct SearchDistance {
        static let lat: CGFloat = 400
        static let lon: CGFloat = 400
    }
}
