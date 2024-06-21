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
    
    @Binding var isSelected: Bool
    @Binding var selectedAnnotation: CustomPointAnnotation?

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
        print("Updating UI view...")
        if let region = mapViewModel.region {
            uiView.setRegion(region, animated: true)
        }
        uiView.addAnnotations(mapViewModel.annotations)
        
        if let selectedAnnotation = selectedAnnotation {
            uiView.selectAnnotation(selectedAnnotation, animated: true)
        } else {
            uiView.deselectAnnotation(uiView.selectedAnnotations.first, animated: true)
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
                parent.selectedAnnotation = annotation
                parent.isSelected = true
                mapViewModel.selectAnnotation(annotation)
                print("-----ANNOTATION SELECTED")
                print("Is selected: ", parent.isSelected)
                print("Annotation: ", Int(parent.selectedAnnotation?.id ?? -1))

                DispatchQueue.main.async {
                    self.mapViewModel.objectWillChange.send()
                }
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if let _ = view.annotation as? CustomPointAnnotation {
                parent.selectedAnnotation = nil
                parent.isSelected = false
                print("-----ANNOTATION DE-SELECTED")
                print("Is selected: ", parent.isSelected)
                print("Annotation: ", Int(parent.selectedAnnotation?.id ?? -1))
            }
        }
    }

}
