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
            TextField("", text: $text, onCommit: {
                hideKeyboard()
            })
            .padding(.top, 16)
            .formFieldViewModifier()
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .offset(x: 10, y: -14)
        }
    }
}


struct BTSecureField: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            SecureField("", text: $text, onCommit: {
                hideKeyboard()
            })
            .padding(.top, 16)
            .formFieldViewModifier()
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .offset(x: 10, y: -14)
        }
    }
}


struct BTTextEditor: View {
    let label: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextEditor(text: $text)
            .padding(.top, 16)
            .frame(height: 200)
            .scrollContentBackground(.hidden)
            .formFieldViewModifier()
            Text(label)
                .font(.caption)
                .foregroundColor(.black)
                .offset(x: 10, y: -94)
        }
    }
}
