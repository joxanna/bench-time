//
//  BTFormField.swift
//  benchTime
//
//  Created by Joanna Xue on 4/7/2024.
//

import SwiftUI

struct BTFormField: View {
    let label: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextField("", text: $text, onCommit: {
                hideKeyboard()
            })
            .padding(.top, 16)
            .frame(height: 44)  // Standard height for text fields
            .formFieldViewModifier()
            .focused($isFocused)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .padding(.leading, 10)  // Ensure label padding is consistent
                .padding(.top, 10)      // Adjust top padding for consistent label positioning
                .background(Color.clear)  // Ensure background doesn’t interfere
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true  // Trigger focus when the ZStack is tapped
        }
    }
}

struct BTSecureField: View {
    let label: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            SecureField("", text: $text, onCommit: {
                hideKeyboard()
            })
            .padding(.top, 16)
            .frame(height: 44)  // Standard height for text fields
            .formFieldViewModifier()
            .focused($isFocused)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .padding(.leading, 10)  // Ensure label padding is consistent
                .padding(.top, 10)      // Adjust top padding for consistent label positioning
                .background(Color.clear)  // Ensure background doesn’t interfere
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true  // Trigger focus when the ZStack is tapped
        }
    }
}

struct BTTextEditor: View {
    let label: String
    @Binding var text: String
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(.top, 16)
                .frame(height: 250)
                .scrollContentBackground(.hidden)  // Hide default background for the scrollable content
                .formFieldViewModifier()
                .focused($isFocused)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .padding(.leading, 10)  // Adjusted to avoid magic numbers and maintain consistency
                .padding(.top, 10)  // Added top padding to align with TextEditor padding
                .background(Color.clear)  // Ensure background doesn’t interfere with the TextEditor
        }
        .contentShape(Rectangle())  // Ensure the entire ZStack is tappable
        .onTapGesture {
            isFocused = true  // Trigger focus when the ZStack is tapped
        }
    }
}
