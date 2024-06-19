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
    var onRegionChange: ((MKCoordinateRegion) -> Void)?
    @Binding var selectedAnnotation: CustomPointAnnotation?
    @Binding var isSelected: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        
        mapViewModel.setRegion = { region in
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
        if let region = mapViewModel.region {
            uiView.setRegion(region, animated: true)
        }
        uiView.addAnnotations(mapViewModel.annotations)
        
        if let selectedAnnotation = mapViewModel.selectedAnnotation {
            uiView.selectAnnotation(selectedAnnotation, animated: true)
            self.selectedAnnotation = selectedAnnotation
            self.isSelected = true;
        } else {
            self.isSelected = false;
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, mapViewModel: mapViewModel)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var mapViewModel: MapViewViewModel

        init(_ parent: MapView, mapViewModel: MapViewViewModel) {
            self.parent = parent
            self.mapViewModel = mapViewModel
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return mapViewModel.view(for: annotation)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.onRegionChange?(mapView.region)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? CustomPointAnnotation {
                mapViewModel.selectAnnotation(annotation)
            }
        }
    }
}
