//
//  ScrollViewWithBouncingDisabled.swift
//  benchTime
//
//  Created by Joanna Xue on 6/7/2024.
//

import SwiftUI

//struct ScrollViewWithBouncingDisabled<Content: View>: UIViewRepresentable {
//    let content: Content
//    
//    func makeUIView(context: Context) -> UIScrollView {
//        let scrollView = UIScrollView()
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.bounces = false // Disable bouncing
//        scrollView.delegate = context.coordinator
//        return scrollView
//    }
//    
//    func updateUIView(_ uiView: UIScrollView, context: Context) {
//        let host = UIHostingController(rootView: content)
//        host.view.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Remove any previous content views
//        uiView.subviews.forEach { $0.removeFromSuperview() }
//        uiView.addSubview(host.view)
//        
//        NSLayoutConstraint.activate([
//            host.view.topAnchor.constraint(equalTo: uiView.topAnchor),
//            host.view.leadingAnchor.constraint(equalTo: uiView.leadingAnchor),
//            host.view.trailingAnchor.constraint(equalTo: uiView.trailingAnchor),
//            host.view.bottomAnchor.constraint(equalTo: uiView.bottomAnchor),
//            host.view.widthAnchor.constraint(equalTo: uiView.widthAnchor),
//        ])
//        
//        // Update the content size to match the content
//        host.view.setNeedsLayout()
//        host.view.layoutIfNeeded()
//        uiView.contentSize = host.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//    
//    class Coordinator: NSObject, UIScrollViewDelegate {
//        // Add methods if you need to handle UIScrollViewDelegate events
//    }
//}
