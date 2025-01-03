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
    private var client: OPClient
    var mapViewModel: MapViewViewModel
    var elements = [Int: OPElement]()
    
    private var fetchWorkItem: DispatchWorkItem?
    
    init() {
        self.client = OPClient()
        self.mapViewModel = MapViewViewModel()
        self.client.endpoint = .kumiSystems
        print("Initialized endpoint: ", client.endpoint.urlString)
    }
    
    func getBench(annotation: CustomPointAnnotation) -> OPElement? {
        let id = annotation.id
        return elements[id]
    }
    
    func findAnnotation(benchId: String) -> CustomPointAnnotation? {
        for annotation in mapViewModel.annotations {
            let id = String(annotation.id)
            if id == benchId {
                return annotation
            }
        }
        print("No annotation found for bench")
        return nil
    }

    func fetchBenches(for region: MKCoordinateRegion, isLoading: Binding<Bool>, completion: @escaping (Result<Void, Error>) -> Void) {
        print("-----Fetching from benchQueryModel")

        // Cancel any existing fetch request
        fetchWorkItem?.cancel()

        // Create a new work item
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else {
                print("Self is nil")
                return
            }

            DispatchQueue.main.async {
                isLoading.wrappedValue = true
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

            self.client.fetchElements(query: query) { result in
                DispatchQueue.main.async {
                    print("Fetch completed")
                    isLoading.wrappedValue = false // Update regardless of result
                    
                    switch result {
                    case .failure(let error):
                        print("Error: \(error)")
                        completion(.failure(error))
                    case .success(let elements):
                        self.elements = elements // Update elements on the main thread
                        // Generate mapKit visualizations for the returned elements using a static visualization generator
                        let visualizations = OPVisualizationGenerator.mapKitVisualizations(forElements: elements)
                        self.mapViewModel.addVisualizations(visualizations)
                        print("Successful fetch to Overpass API")
                        completion(.success(()))
                    }
                }
            }
        }

        // Store the new work item and schedule it with a delay (e.g., 0.5 seconds)
        fetchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}
