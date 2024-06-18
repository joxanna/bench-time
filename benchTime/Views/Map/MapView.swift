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
    @Binding var selectedAnnotation: MKAnnotation?
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
        mapViewModel.addOverlays = { overlays in
            mapView.addOverlays(overlays)
        }
        mapViewModel.removeAnnotations = { annotations in
            mapView.removeAnnotations(annotations)
        }
        mapViewModel.removeOverlays = { overlays in
            mapView.removeOverlays(overlays)
        }
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let region = mapViewModel.region {
            uiView.setRegion(region, animated: true)
        }
        uiView.addAnnotations(mapViewModel.annotations)
        uiView.addOverlays(mapViewModel.overlays)
        
        if let selectedAnnotation = mapViewModel.selectedAnnotation {
            uiView.selectAnnotation(selectedAnnotation, animated: true)
            self.selectedAnnotation = selectedAnnotation
            self.isSelected = true;
            print("Selected Annotation: ", selectedAnnotation)
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

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            return mapViewModel.renderer(for: overlay)
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            return mapViewModel.view(for: annotation)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.onRegionChange?(mapView.region)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? MKPointAnnotation {
                mapViewModel.selectAnnotation(annotation)
            }
        }
    }
}
