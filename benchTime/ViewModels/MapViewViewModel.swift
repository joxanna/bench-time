//
//  MapViewModel.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

import SwiftUI
import MapKit
import SwiftOverpassAPI

class CustomPointAnnotation: MKPointAnnotation {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}

class MapViewViewModel: ObservableObject {
    
    // All MapKit Overpass Visualizations
    var visualizations = [Int: OPMapKitVisualization]()
    
    var annotations = [CustomPointAnnotation]() // Annotations generated from center visualizations
    var overlays = [MKOverlay]() // Overlays generated from polygon/polyline type visualizations.
    
    // Variable for storing/setting the bound mapView's region
    var region: MKCoordinateRegion? {
        didSet {
            guard let region = region else { return }
            setRegion?(region)
        }
    }
    
    // Reuse identifier for marker annotation views.
    private let markerReuseIdentifier = "MarkerAnnotationView"
    
    // Handler functions for set the bound mapView's region and adding/removing annotations and overlays
    var setRegion: ((MKCoordinateRegion) -> Void)?
    var addAnnotations: (([CustomPointAnnotation]) -> Void)?
    var removeAnnotations: (([CustomPointAnnotation]) -> Void)?
    
    /* ------------- */
    func selectAnnotation(_ annotation: CustomPointAnnotation) {
        region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
    }

    /* ------------- */
    
    // Function to register all reusable annotation views to the mapView
    func registerAnnotationViews(to mapView: MKMapView) {
        mapView.register(
            MKMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: markerReuseIdentifier)
    }
    
    // Convert visualizations to MapKit overlays and annoations
    func addVisualizations(_ visualizations: [Int: OPMapKitVisualization]) {
        
        self.visualizations = visualizations
        
        removeAnnotations?(annotations)
        annotations = []
     
        var newAnnotations = [CustomPointAnnotation]()
        var polylines = [MKPolyline]()
        var polygons = [MKPolygon]()
        
        // For each visualization, append it to annotations, polylines, or polygons array depending on it's type.
        for (key, visualization) in visualizations {
            switch visualization {
            case .annotation(let annotation):
                if let pointAnnotation = annotation as? MKPointAnnotation {
                    let customAnnotation = CustomPointAnnotation(id: key)
                    customAnnotation.coordinate = pointAnnotation.coordinate
                    newAnnotations.append(customAnnotation)
                }
            case .polyline(let polyline):
                polylines.append(polyline)
            case .polylines(let newPolylines):
                polylines.append(contentsOf: newPolylines)
            case .polygon(let polygon):
                polygons.append(polygon)
            case .polygons(let newPolygons):
                polygons.append(contentsOf: newPolygons)
            }
        }
        
        // Store the new annotations and overlays in their respective variables
        annotations = newAnnotations
        
        // Add the annotaitons and overlays to the mapView
        addAnnotations?(annotations)
    }
    
    // Set the annotaiton view for annotations visualized on the mapView
    func view(for annotation: MKAnnotation) -> MKAnnotationView? {
        guard let pointAnnotation = annotation as? MKPointAnnotation else {
            return nil
        }
        let view = MKMarkerAnnotationView(
            annotation: pointAnnotation,
            reuseIdentifier: markerReuseIdentifier)
        
        view.markerTintColor = UIStyles.Colors.theme
        return view
    }
}
