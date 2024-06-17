//
//  LocationManager.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

//import SwiftUI
//import MapKit
//import SwiftOverpassAPI
//
//class LocationService: NSObject, MKLocalSearchCompleterDelegate {
//    let queryRegion = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(
//            latitude: 37.7749,
//            longitude: -122.4194),
//        latitudinalMeters: 50000,
//        longitudinalMeters: 50000)
//    
//    func run() {
//        let boundingBox = OPBoundingBox(region: queryRegion)
//        
//        // create query
//        do {
//            let query = try OPQueryBuilder()
//                .setTimeOut(180) //1
//                .setElementTypes([.relation]) //2
//                .addTagFilter(key: "network", value: "BART", exactMatch: false) //3
//                .addTagFilter(key: "type", value: "route") //4
//                .addTagFilter(key: "name") //5
//                .setBoundingBox(boundingBox) //6
//                .setOutputType(.geometry) //7
//                .buildQueryString() //8
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        let boundingBoxString = OPBoundingBox(region: queryRegion).toString()
//
//        let query = """
//                data=[out:json];
//                node["network"="BART"]
//                ["railway"="stop"]
//                \(boundingBoxString)
//                ->.bartStops;
//                (
//                way(around.bartStops:200)["amenity"="cinema"];
//                node(around.bartStops:200)["amenity"="cinema"];
//                );
//                out center;
//                """
//        
//        let client = OPClient() //1
//        client.endpoint = .kumiSystems //2
//
//        //3
//        client.fetchElements(query: query) { result in
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let elements):
//                print(elements) // Do something with returned the elements
//                let visualizations = OPVisualizationGenerator
//                    .mapKitVisualizations(forElements: elements)
//            }
//        }
//       
//    }
//
//    
//    func addVisualizations(_ visualizations: [Int: OPMapKitVisualization]) {
//            
//        var annotations = [MKAnnotation]()
//        var polylines = [MKPolyline]()
//        var polygons = [MKPolygon]()
//            
////        for visualization in visualizations.values {
////            switch visualization {
////            case .annotation(let annotation):
////                newAnnotations.append(annotation)
////            case .polyline(let polyline):
////                polylines.append(polyline)
////            case .polylines(let newPolylines):
////                polylines.append(contentsOf: newPolylines)
////            case .polygon(let polygon):
////                polygons.append(polygon)
////            case .polygons(let newPolygons):
////                polygons.append(contentsOf: newPolygons)
////            }
////        }
////
////        if #available(iOS 13, *) {
////            // MKMultipolyline and MKMultipolygon generate a single renderer for all of their elements. If available, it is more efficient than creating a renderer for each overlay.
////            let multiPolyline = MKMultiPolyline(polylines)
////            let multiPolygon = MKMultiPolygon(polygons)
////            mapView.addOverlay(multiPolygon)
////            mapView.addOverlay(multiPolyline)
////        } else {
////            mapView.addOverlays(polygons)
////            mapView.addOverlays(polylines)
////        }
////
////        mapView.addAnnotations(annotations)
//    }
//}
//
//extension MapViewController: MKMapViewDelegate {
//    // Delegate method for rendering overlays
//    func mapView(
//        _ mapView: MKMapView,
//        rendererFor overlay: MKOverlay) -> MKOverlayRenderer
//    {
//        let strokeWidth: CGFloat = 2
//        let strokeColor = UIStyles.Colors.theme
//        let fillColor = UIStyles.Colors.theme.withAlphaComponent(0.5)
//        
//        if let polyline = overlay as? MKPolyline {
//            let renderer = MKPolylineRenderer(
//                polyline: polyline)
//            renderer.strokeColor = strokeColor
//            renderer.lineWidth = strokeWidth
//            return renderer
//        } else if let polygon = overlay as? MKPolygon {
//            let renderer = MKPolygonRenderer(
//                polygon: polygon)
//            renderer.fillColor = fillColor
//            renderer.strokeColor = strokeColor
//            renderer.lineWidth = strokeWidth
//            return renderer
//        }    else if let multiPolyline = overlay as? MKMultiPolyline {
//            let renderer = MKMultiPolylineRenderer(
//                multiPolyline: multiPolyline)
//            renderer.strokeColor = strokeColor
//            renderer.lineWidth = strokeWidth
//            return renderer
//        } else if let multiPolygon = overlay as? MKMultiPolygon {
//            let renderer = MKMultiPolygonRenderer(
//                multiPolygon: multiPolygon)
//            renderer.fillColor = fillColor
//            renderer.strokeColor = strokeColor
//            renderer.lineWidth = strokeWidth
//            return renderer
//        } else {
//            return MKOverlayRenderer()
//        }
//    }
//
//    /*
//        // Make sure to add the following when configure your mapView:
//        
//        let markerReuseIdentifier = "MarkerAnnotationView"
//        
//        mapView.register(
//            MKMarkerAnnotationView.self,
//            forAnnotationViewWithReuseIdentifier: markerReuseIdentifier)
//    */
//    
////    // Delegate method for setting annotation views.
////    func mapView(
////        _ mapView: MKMapView,
////        viewFor annotation: MKAnnotation) -> MKAnnotationView?
////    {
////        guard
////            let pointAnnotation = annotation as? MKPointAnnotation
////        else {
////            return nil
////        }
////        
////        let view = MKMarkerAnnotationView(
////            annotation: pointAnnotation,
////            reuseIdentifier: markerReuseIdentifier)
////        
////        view.markerTintColor = UIStyles.Colors.theme
////        return view
////    }
//}
