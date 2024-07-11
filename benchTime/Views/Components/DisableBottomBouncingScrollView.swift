//
//  DisableBottomBouncingScrollView.swift
//  benchTime
//
//  Created by Joanna Xue on 11/7/2024.
//

import UIKit
import SwiftUI

struct UIScrollViewRepresentable<Content: View>: UIViewControllerRepresentable {
    let content: () -> Content
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let scrollView = UIScrollView(frame: viewController.view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.frame = scrollView.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        scrollView.addSubview(hostingController.view)
        viewController.addChild(hostingController)
        hostingController.didMove(toParent: viewController)
        
        // Adjust the scroll view content size to match the content view size
        hostingController.view.onSizeChange { size in
            scrollView.contentSize = size
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Access the scroll view and its hosting controller
        guard let scrollView = uiViewController.view.subviews.first as? UIScrollView,
              let hostingController = scrollView.subviews.first as? UIHostingController<Content> else {
            return
        }
        
        // Update the root view of the hosting controller
        hostingController.rootView = content()
        
        // Update the frame of the hosting controller's view to match the scroll view's bounds
        hostingController.view.frame = scrollView.bounds
        
        // Call onSizeChange to update the content size of the scroll view
        hostingController.view.onSizeChange { size in
            scrollView.contentSize = size
        }
    }

}

extension UIView {
    func onSizeChange(_ handler: @escaping (CGSize) -> Void) {
        let observer = self.observe(\.bounds, options: [.new]) { view, change in
            if let newSize = change.newValue?.size {
                handler(newSize)
            }
        }
        
        // Store the observer as an associated object to keep it alive
        objc_setAssociatedObject(self, &AssociatedKeys.sizeChangeObserver, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private struct AssociatedKeys {
        static var sizeChangeObserver = "sizeChangeObserver"
    }
}




//func scrollViewDidScroll(_ scrollView: UIScrollView) {
//    // Fix the bounce at the bottom
//    if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
//        scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.bounds.height
//    }
//}
