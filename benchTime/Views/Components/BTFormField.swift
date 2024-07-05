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
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .offset(x: 10, y: -14)
            TextField("", text: $text, onCommit: {
                hideKeyboard()
            })
            .padding(.top, 16)
            .formFieldViewModifier()
        }
    }
}


struct BTSecureField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .offset(x: 10, y: -14)
            SecureField("", text: $text, onCommit: {
                hideKeyboard()
            })
            .padding(.top, 16)
            .formFieldViewModifier()
        }
    }
}


struct BTTextEditor: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .offset(x: 10, y: -94)
            TextEditor(text: $text)
            .padding(.top, 16)
            .frame(height: 200)
            .scrollContentBackground(.hidden)
            .formFieldViewModifier()
        }
    }
}
