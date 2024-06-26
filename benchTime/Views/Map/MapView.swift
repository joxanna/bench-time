//
//  MapView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var mapViewModel: MapViewViewModel
    var onRegionChange: ((MKCoordinateRegion, Binding<Bool>) -> Void)?
    
    @Binding var isSelected: Bool
    @Binding var selectedAnnotation: CustomPointAnnotation?
    @Binding var isLoading: Bool
    @Binding var isSearching: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        // Add compass
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        
        mapView.addSubview(compassButton)
        
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -UIStyles.Padding.medium).isActive = true
        compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 72).isActive = true
        
        // Add tracking button
        let trackingButton = UIButton(type: .system)
        trackingButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        trackingButton.tintColor = .systemBlue
        trackingButton.addTarget(context.coordinator, action: #selector(context.coordinator.trackingButtonTapped), for: .allTouchEvents)
        mapView.addSubview(trackingButton)
        
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -UIStyles.Padding.xlarge).isActive = true
        trackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 124).isActive = true
        
        // Add pin button
        let pinButton = UIButton(type: .system)
        pinButton.setImage(UIImage(systemName: "mappin"), for: .normal)
        pinButton.tintColor = .systemRed
        pinButton.addTarget(context.coordinator, action: #selector(context.coordinator.pinButtonTapped), for: .allTouchEvents)
        mapView.addSubview(pinButton)
        
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -UIStyles.Padding.xlarge).isActive = true
        pinButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 160).isActive = true
        
        if let imageView = pinButton.imageView {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        }
        
        pinButton.isHidden = !mapViewModel.hasSearchPin
        pinButton.tag = 3
        
        mapViewModel.setRegion = { region in
            context.coordinator.isProgrammaticRegionChange = true
            mapView.setRegion(region, animated: true)
        }
        mapViewModel.addAnnotations = { annotations in
            mapView.addAnnotations(annotations)
        }
        mapViewModel.removeAnnotations = { annotations in
            mapView.removeAnnotations(annotations)
        }
        
        context.coordinator.mapView = mapView
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if (isSearching) {
            
        } else {
            print("-----Updating UI view")
            // Update the region if it has changed and the change is not programmatic
            if let region = mapViewModel.region, !context.coordinator.isProgrammaticRegionChange {
                print("Setting region to: \(region.center.latitude), \(region.center.longitude)")
                uiView.setRegion(region, animated: true)
            }
            
            // Select or deselect annotations as needed
            if let selectedAnnotation = selectedAnnotation {
                print("Select annotation")
                uiView.selectAnnotation(selectedAnnotation, animated: true)
            } else {
                print("De-select annotation")
                uiView.deselectAnnotation(uiView.selectedAnnotations.first, animated: true)
            }

            // Remove annotations if isSelected is false
            if !isSelected {
                print("Remove annotations")
                uiView.removeAnnotations(uiView.annotations)
            }
            
            if let searchPin = mapViewModel.searchPin {
                print("Adding search pin at: \(searchPin.coordinate.latitude), \(searchPin.coordinate.longitude)")
                uiView.addAnnotation(searchPin)
            }
            
            uiView.subviews.compactMap { $0 as? UIButton }.forEach {
                if $0.tag == 3 { // Handle visibility of search pin button
                    $0.isHidden = !mapViewModel.hasSearchPin
                }
            }

            uiView.addAnnotations(mapViewModel.annotations)
            print("Add annotations")
        }
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, mapViewModel: mapViewModel)
    }

    class Coordinator: NSObject, MKMapViewDelegate, UISearchBarDelegate {
        var parent: MapView
        var mapViewModel: MapViewViewModel
        var isProgrammaticRegionChange = false
        var mapView: MKMapView?

        init(_ parent: MapView, mapViewModel: MapViewViewModel) {
            self.parent = parent
            self.mapViewModel = mapViewModel
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is CustomPointAnnotation {
                return mapViewModel.viewBench(for: annotation)
            } else {
                return mapViewModel.viewSearch(for: annotation)
            }
        }
        

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Stop unwanted calls
            if isProgrammaticRegionChange {
                isProgrammaticRegionChange = false
                return
            }

            if parent.isSearching {
                return
            }
            
            print("-----Region change triggered")
            parent.onRegionChange?(mapView.region, parent.$isLoading)
            isProgrammaticRegionChange = true
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? CustomPointAnnotation {
                parent.selectedAnnotation = annotation
                mapViewModel.selectAnnotation(annotation, isTrackingModeFollow: mapView.userTrackingMode == .follow)
                parent.isSelected = true
                isProgrammaticRegionChange = true // if changing region causes re-render
                print("-----Annotation selected")
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if let _ = view.annotation as? CustomPointAnnotation {
                parent.selectedAnnotation = nil
                parent.isSelected = false
                print("-----Annotation de-selected")
            }
        }
        
        func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
            // Check if user switched to follow mode
            if mode == .follow {
                // Preserve the search pin on the map
                if let searchPin = mapViewModel.searchPin {
                    print("Preserve search pin")
                    mapView.addAnnotation(searchPin)
                }
            }
        }
        
        @objc func trackingButtonTapped() {
            print("-----Re-center")
            if mapView?.userTrackingMode == .follow {
                print("Don't follow")
                mapView?.setUserTrackingMode(.none, animated: true)
                // Fetch benches at current location
                if let location = mapView?.userLocation.location {
                    let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: UIStyles.SearchDistance.lat, longitudinalMeters: UIStyles.SearchDistance.lon)
                    mapView?.setRegion(region, animated: true)
                }
            } else {
                print("Follow")
                mapView?.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
                
            }
        }
        
        @objc func pinButtonTapped() {
            print("-----Pin button tapped")
            if let searchPin = mapViewModel.searchPin {
                let region = MKCoordinateRegion(center: searchPin.coordinate, latitudinalMeters: UIStyles.SearchDistance.lat, longitudinalMeters: UIStyles.SearchDistance.lon)
                mapView?.setRegion(region, animated: true)
            }
        }
    }
}
