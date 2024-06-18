//
//  SearchBenchesView.swift
//  benchTime
//
//  Created by Joanna Xue on 23/5/2024.
//

import SwiftUI
import MapKit
import CoreLocation

struct SearchBenchesView: View {
    @ObservedObject var benchQueryManager = BenchQueryManager.shared
    @StateObject private var locationManager = LocationManager.shared

    var body: some View {
        VStack {
            MapView(mapViewModel: benchQueryManager.mapViewModel, onRegionChange: { region in
                benchQueryManager.fetchBenches(for: region)
            })
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                locationManager.requestLocation()
            }
            .onChange(of: locationManager.lastLocation) { _, newLocation in
                if let newLocation = newLocation {
                    let region = MKCoordinateRegion(
                        center: newLocation.coordinate,
                        latitudinalMeters: 500,
                        longitudinalMeters: 500)
                    benchQueryManager.mapViewModel.region = region
                    benchQueryManager.fetchBenches(for: region)
                }
            }
            
            Text("Pull up")
        }
    }
}
