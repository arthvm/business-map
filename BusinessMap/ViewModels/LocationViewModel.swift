//
//  MapViewModel.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 14/08/25.
//

import Foundation
import MapKit
import CoreLocation
import Combine
import SwiftUI

@MainActor
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published private(set) var userLocation: CLLocationCoordinate2D?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if let coordinate = manager.location?.coordinate {
                cameraPosition = .camera(
                    MapCamera(
                        centerCoordinate: coordinate,
                        distance: 500,
                        heading: 0,
                        pitch: 0
                    )
                )
                
                userLocation = coordinate
            }
        }
    }
    
    func centerMap(on coordinate: CLLocationCoordinate2D) {
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
