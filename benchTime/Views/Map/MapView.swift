//
//  MapView.swift
//  benchTime
//
//  Created by Joanna Xue on 18/5/2024.
//

import SwiftUI

struct MapView: View {
    @ObservedObject var benchQueryManager = BenchQueryManager.shared
    
    var body: some View {
        VStack {
            Text("Map")
                .font(.headline)
            Button(action: {
                benchQueryManager.fetchBenches()
            }) {
                Text("Fetch Benches")
            }
        }
    }
}
