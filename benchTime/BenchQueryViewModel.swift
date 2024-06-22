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
    
    func fetchBenches(for region: MKCoordinateRegion, isLoading: Binding<Bool>) {
        print("-----Fetching from benchQueryModel")
        DispatchQueue.main.async {
            isLoading.wrappedValue = true
            print("Is loading should be true: ", isLoading.wrappedValue)
        }
        
        let minLat = region.center.latitude - region.span.latitudeDelta / 2
        let maxLat = region.center.latitude + region.span.latitudeDelta / 2
        let minLon = region.center.longitude - region.span.longitudeDelta / 2
        let maxLon = region.center.longitude + region.span.longitudeDelta / 2

        let query = """
        [out:json];
        node["amenity"="bench"](\(minLat),\(minLon),\(maxLat),\(maxLon));
        out body;
        """
        
        client.fetchElements(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Error fetching elements: \(error.localizedDescription)")
                    if let urlError = error as? URLError {
                        print("URLError code: \(urlError.code)")
                    }
                    isLoading.wrappedValue = false
                case .success(let elements):
                    self.elements = elements // Update elements on the main thread
                    // Generate mapKit visualizations for the returned elements using a static visualization generator
                    let visualizations = OPVisualizationGenerator.mapKitVisualizations(forElements: elements)
                    self.mapViewModel.addVisualizations(visualizations)
                    print("Successful fetch to Overpass API")
                    isLoading.wrappedValue  = false // Update isLoading on the main thread
                    print("Is loading should be false: ", isLoading.wrappedValue)
                }
            }
        }
    }
}
