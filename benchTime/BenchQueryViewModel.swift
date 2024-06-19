//
//  BenchQueryManager.swift
//  benchTime
//
//  Created by Joanna Xue on 12/6/2024.
//

import Foundation
import SwiftOverpassAPI
import CoreLocation
import SwiftUI
import MapKit

class BenchQueryViewModel: ObservableObject {
    var client: OPClient
    var mapViewModel: MapViewViewModel
    var elements = [Int: OPElement]()
    
    var isLoading: Bool = false
    
    init() {
        self.client = OPClient()
        self.mapViewModel = MapViewViewModel()
        self.client.endpoint = .kumiSystems
        print("Initialised endpoint: ", client.endpoint.urlString)
    }
    
    func getBench(annotation: CustomPointAnnotation) -> OPElement? {
        let id = annotation.id
        return elements[id]
    }
    
    func fetchBenches(for region: MKCoordinateRegion) {
        self.isLoading = true
        
        let minLat = region.center.latitude - region.span.latitudeDelta / 2
        let maxLat = region.center.latitude + region.span.latitudeDelta / 2
        let minLon = region.center.longitude - region.span.longitudeDelta / 2
        let maxLon = region.center.longitude + region.span.longitudeDelta / 2

        let query = """
        [out:json];
        node["amenity"="bench"](\(minLat),\(minLon),\(maxLat),\(maxLon));
        out body;
        """

        print("Making request...")
        
        client.fetchElements(query: query) { result in
            switch result {
            case .failure(let error):
                print("Error fetching elements: \(error.localizedDescription)")
                if let urlError = error as? URLError {
                    print("URLError code: \(urlError.code)")
                }
            case .success(let elements):
                self.elements = elements // Update elements on the main thread
                // Generate mapKit visualizations for the returned elements using a static visualization generator
                let visualizations = OPVisualizationGenerator.mapKitVisualizations(forElements: elements)
                self.mapViewModel.addVisualizations(visualizations)
                print("Successful fetch to Overpass API")
                self.isLoading = false // Update isLoading on the main thread
            }
        }
    }
}
