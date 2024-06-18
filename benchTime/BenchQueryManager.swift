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

class BenchQueryManager: ObservableObject {
    static let shared = BenchQueryManager()
    
    private var client: OPClient
    var mapViewModel: MapViewViewModel
    var elements = [Int: OPElement]()
    var isLoading: Bool = false
    
    private init() {
        client = OPClient()
        client.endpoint = .kumiSystems
        mapViewModel = MapViewViewModel()
        print("Initialised endpoint: ", client.endpoint.urlString)
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

        print("Query: ", query)
        print("Making request...")
        
        client.fetchElements(query: query) { result in
            switch result {
            case .failure(let error):
                print("Error fetching elements: \(error.localizedDescription)")
                if let urlError = error as? URLError {
                    print("URLError code: \(urlError.code)")
                }
            case .success(let elements):
                print("Successful fetch to Overpass API")
                self.elements = elements
                print(elements)
                
                // Generate mapKit visualizations for the returned elements using a static visualization generator
                let visualizations = OPVisualizationGenerator
                    .mapKitVisualizations(forElements: elements)
                self.mapViewModel.addVisualizations(visualizations)
            }
            self.isLoading = false
        }
    }
        
}
