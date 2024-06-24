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

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        // Add tracking button
        let trackingButton = UIButton(type: .system)
        trackingButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        trackingButton.tintColor = .systemBlue
        trackingButton.addTarget(context.coordinator, action: #selector(context.coordinator.trackingButtonTapped), for: .allTouchEvents)
        mapView.addSubview(trackingButton)
        
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
        trackingButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -UIStyles.Padding.xlarge).isActive = true
        trackingButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 72).isActive = true
        
        // Add compass
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .visible
        
        mapView.addSubview(compassButton)
        
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -UIStyles.Padding.medium).isActive = true
        compassButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: UIStyles.Padding.medium).isActive = true
        
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
        print("-----Updating UI view")

        // Update the region if it has changed and the change is not programmatic
        if let region = mapViewModel.region, !context.coordinator.isProgrammaticRegionChange {
            print("Setting region to: \(region.center.latitude), \(region.center.longitude)")
            uiView.setRegion(region, animated: true)
        }
        
        // Select or deselect annotations as needed
        if let selectedAnnotation = selectedAnnotation {
            uiView.selectAnnotation(selectedAnnotation, animated: true)
        } else {
            uiView.deselectAnnotation(uiView.selectedAnnotations.first, animated: true)
        }

        // Remove annotations if isSelected is false
        if !isSelected {
            uiView.removeAnnotations(uiView.annotations)
        }
        
        if let searchPin = mapViewModel.searchPin {
            print("Adding search pin at: \(searchPin.coordinate.latitude), \(searchPin.coordinate.longitude)")
            uiView.addAnnotation(searchPin)
        }
        uiView.addAnnotations(mapViewModel.annotations)
    }

    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, mapViewModel: mapViewModel)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
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
            if isProgrammaticRegionChange {
                isProgrammaticRegionChange = false
                return
            }
            
            print("-----Region change")
            parent.onRegionChange?(mapView.region, parent.$isLoading)
            isProgrammaticRegionChange = true // prevent re-render
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
            } else {
                print("Follow")
                mapView?.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
            }
        }

    }
}
