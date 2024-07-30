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
        static let darkGray = Color(red: 0.28, green: 0.28, blue: 0.28)
        static let lightGray = Color(red: 0.89, green: 0.89, blue: 0.89)
        static let gray = Color.gray
        static let red = Color(red: 0.812, green: 0.259, blue: 0.259)
        static let theme = UIColor.blue
        static let disabled = Color.gray
        static let accent = Color.orange
        
        struct Light {
            static let link = Color.cyan
            static let formField = Color.gray.opacity(0.05)
            static let label = Color.black
            static let card = Color.white
            static let shadow = Color.gray.opacity(0.3)
        }
        
        struct Dark {
            static let link = Color(.systemBlue)
            // static let link = Color(red: 0.35, green: 0.53, blue: 0.94)
            static let formField = Color.gray.opacity(0.4)
            static let label = Color.white
            static let card = Color(red: 0.1, green: 0.1, blue: 0.1)
        }
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
