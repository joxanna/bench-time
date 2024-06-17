//
//  MapViewController.swift
//  benchTime
//
//  Created by Joanna Xue on 24/5/2024.
//

import UIKit
import MapKit

// A basic MVVM MapViewController
class MapViewController: UIViewController {
    
    // If a portion of the mapView is obscured we can set edge insets to move the mapView content to the mapView's visible area.
    private var edgeInsets: UIEdgeInsets?
    
    // Initializing the mapView and setting the controller to be it's delegate
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    // The view model that governs what content the mapView displays
    let viewModel: MapViewModel
    
    // Initialize with a view model
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        
        // After initialization, add pan, pinch, and rotation gestures so that we can notify the view model whenever the user physically interacts with the mapView.
        let panGesureRecognizer = UIPanGestureRecognizer.init(
            target: self,
            action: #selector(userDidGestureOnMapView(sender:)))
        
        panGesureRecognizer.delegate = self
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer.init(
            target: self,
            action: #selector(userDidGestureOnMapView(sender:)))
        
        pinchGestureRecognizer.delegate = self
        
        let rotationGestureRecognizer = UIRotationGestureRecognizer.init(
            target: self,
            action: #selector(userDidGestureOnMapView(sender:)))
        
        rotationGestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(panGesureRecognizer)
        mapView.addGestureRecognizer(pinchGestureRecognizer)
        mapView.addGestureRecognizer(rotationGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // On view did load we configure tha mapViewModel's handler functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register all reusable annotatino views to the mapView
        viewModel.registerAnnotationViews(to: mapView)
        
        // Called whenever the mapView should set a new region
        viewModel.setRegion = { [weak self] region in
            self?.updateRegion(to: region)
        }
        
        // Called whenever the mapView should add annotations
        viewModel.addAnnotations = { [weak self] annotations in
            self?.mapView.addAnnotations(annotations)
        }
        
        // Called whenever the mapView should add overlays
        viewModel.addOverlays = { [weak self] overlays in
            self?.mapView.addOverlays(overlays)
        }
        
        // Called whenever the mapView should remove annotations
        viewModel.removeAnnotations = { [weak self] annotations in
            self?.mapView.removeAnnotations(annotations)
        }
        
        // Called whenever the mapView should remove overlays
        viewModel.removeOverlays = { [weak self] overlays in
            self?.mapView.removeOverlays(overlays)
        }
        
        // Set the current region specified by the viewModel.
        if let region = viewModel.region {
            mapView.setRegion(region, animated: true)
        }
        
        // Add all of the viewModel's annotations and overlays
        mapView.addAnnotations(viewModel.annotations)
        mapView.addOverlays(viewModel.overlays)
        
        // Configure the mapViewConstraints
        configure()
    }

    // Configure the mapView constraints
    private func configure() {
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    // Called whenever the mapView's edge insets need to change.
    func setEdgeInsets(to edgeInsets: UIEdgeInsets) {
        self.edgeInsets = edgeInsets
        
        guard let region = viewModel.region else {
            return
        }
        
        // After setting the new edge insets, update the mapView region
        updateRegion(to: region)
    }
    
    // Updating the mapView region
    private func updateRegion(to region: MKCoordinateRegion) {
        
        // If no edge insets are specified, simply set the mapView region using the standard mapView method
        guard let edgeInsets = edgeInsets else {
            mapView.setRegion(region, animated: true)
            return
        }
        
        // Otherwise, conver the region to a mapRect and pad the region with the edge insets.
        let rect = region.toMKMapRect()
        
        mapView.setVisibleMapRect(
            rect,
            edgePadding: edgeInsets,
            animated: true)
    }
    
    // Whenever the user gestures on the mapView, notify the viewModel and pass the gesture recognizer.
    @objc func userDidGestureOnMapView(sender: UIGestureRecognizer) {
        viewModel.userDidGestureOnMapView(sender: sender)
    }
}


extension MapViewController: MKMapViewDelegate {
    // Delegate method for rendering overlays
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return viewModel.renderer(for: overlay)
    }
    
    // Delegate method for setting annotation views.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return viewModel.view(for: annotation)
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    // Gesture recognizer delegate method that allows two gesture recognizers to correspond to a single gesture. We do this so we can recognize the user gestures while the standard mapView gestures are still active.
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
}


