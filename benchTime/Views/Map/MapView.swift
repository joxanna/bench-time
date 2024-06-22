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
            print("Deselect")
            uiView.deselectAnnotation(selectedAnnotation, animated: true)
        }

        // Remove annotations if isSelected is false
        if !isSelected {
            let annotationsToRemove = uiView.annotations.filter { annotation in
                // Ensure not to remove the selectedAnnotation or the searchPin
                return annotation !== selectedAnnotation && annotation !== mapViewModel.searchPin
            }
            uiView.removeAnnotations(annotationsToRemove)
        }

        // Add search pin and other annotations
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
                mapViewModel.selectAnnotation(annotation)
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
    }
}
