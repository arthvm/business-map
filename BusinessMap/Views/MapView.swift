//
//  MapView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    let locationManager = CLLocationManager()
    
    var body: some View {
        Map(
            initialPosition: cameraPosition
        ) {
            UserAnnotation()
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
        .onChange(of: locationManager.authorizationStatus) { oldStatus, newStatus in
            if newStatus == .authorizedWhenInUse || newStatus == .authorizedAlways {
                if let coordinate = locationManager.location?.coordinate {
                    cameraPosition = .camera(
                        MapCamera(
                            centerCoordinate: coordinate,
                            distance: 500,
                            heading: 0,
                            pitch: 0
                        )
                    )
                }
            }
        }
    }
}

#Preview {
    MapView()
}
