//
//  ModalView.swift
//  benchTime
//
//  Created by Joanna Xue on 21/5/2024.
//

import SwiftUI

struct LargeModalView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    var title: String?
    var contentView: Content?
    
    var body: some View {
        VStack {
            if let title = title {
                Text(title)
                    .font(.title)
                    .padding()
            }

            contentView
        }
    }
}
