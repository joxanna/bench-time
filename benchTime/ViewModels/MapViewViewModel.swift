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
    
    // Function called to center the mapView on a particular visualization
    func centerMap(onVisualizationWithId id: Int) {
        guard let visualization = visualizations[id] else {
            return
        }
        
        let region: MKCoordinateRegion
        let insetRatio: Double = -0.25
        
        let boundingRects: [MKMapRect]
        
        // If the visualization is an annotation then center on the annotation's coordinate. Otherwise, find the bounding rectangles of every object in the visualization
        switch visualization {
        case .annotation(let annotation):
            region = MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500)
            self.region = region
            return
        case .polyline(let polyline):
            boundingRects = [polyline.boundingMapRect]
        case .polygon(let polygon):
            boundingRects = [polygon.boundingMapRect]
        case .polylines(let polylines):
            boundingRects = polylines.map { $0.boundingMapRect }
        case .polygons(let polygons):
            boundingRects = polygons.map { $0.boundingMapRect }
        }
        
        // Find a larger rectable that encompasses all the bounding rectangles for each individual object in the visualization.
        guard
            let minX = (boundingRects.map { $0.minX }).min(),
            let maxX = (boundingRects.map { $0.maxX }).max(),
            let minY = (boundingRects.map { $0.minY }).min(),
            let maxY = (boundingRects.map { $0.maxY }).max()
        else {
            return
        }
        let width = maxX - minX
        let height = maxY - minY
        let rect = MKMapRect(x: minX, y: minY, width: width, height: height)
        
        // Pad the large rectangle by the specified ratio
        let paddedRect = rect.insetBy(dx: width * insetRatio, dy: height * insetRatio)
        
        // Convert the rectangle to a MKCoordinateRegion
        region = MKCoordinateRegion(paddedRect)
        
        // Set the mapView region to the new visualization-emcompassing region
        self.region = region
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
    
    // If the user changes the region through a gesture, set the stored region to nil. This will stop the mapView from recentering itself when the edge insets change.
    func userDidGestureOnMapView(sender: UIGestureRecognizer) {
        
        if
            sender.isKind(of: UIPanGestureRecognizer.self) ||
            sender.isKind(of: UIPinchGestureRecognizer.self)
        {
            region = nil
        }
    }
}
