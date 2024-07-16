//
//  DisableBottomBouncingScrollView.swift
//  benchTime
//
//  Created by Joanna Xue on 11/7/2024.
//

import UIKit
import SwiftUI

class CustomScrollView: UIScrollView {
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure scroll view properties are correctly set
        self.isScrollEnabled = true
        self.showsVerticalScrollIndicator = false
    }
}

struct NoBounceScrollView<Content: View>: UIViewRepresentable {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    func makeUIView(context: Context) -> CustomScrollView {
        let scrollView = CustomScrollView()
        scrollView.delegate = context.coordinator
        scrollView.backgroundColor = .clear  // Set to clear if you want to see the background of the content
        
        let hostedView = UIHostingController(rootView: content)
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(hostedView.view)
        
        NSLayoutConstraint.activate([
            hostedView.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostedView.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostedView.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostedView.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostedView.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        context.coordinator.hostingController = hostedView

        return scrollView
    }
    
    func updateUIView(_ uiView: CustomScrollView, context: Context) {
        print("Updating scroll view")
        if let hostedView = context.coordinator.hostingController {
            hostedView.rootView = content
            
            // Ensure content size is updated
            let size = hostedView.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            uiView.contentSize = size
            
            uiView.setNeedsLayout()
            uiView.layoutIfNeeded()
            uiView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: NoBounceScrollView
        var hostingController: UIHostingController<Content>?
        
        init(parent: NoBounceScrollView) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            // Fix the bounce at the bottom
            let contentHeight = scrollView.contentSize.height
            let scrollViewHeight = scrollView.bounds.height
            
            if scrollView.contentOffset.y > contentHeight - scrollViewHeight {
                scrollView.contentOffset.y = contentHeight - scrollViewHeight
            }
       
            // Additional scroll handling code here if needed
            print("Scroll offset: \(scrollView.contentOffset.y)")
        }
    }
}
