//
//  LocationStore.swift
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
class LocationStore: NSObject, ObservableObject, CLLocationManagerDelegate {
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
                centerMap(on: coordinate)
                userLocation = coordinate
            }
        }
    }
    
    func centerMap(on coordinate: CLLocationCoordinate2D) {
        cameraPosition = .camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: coordinate.latitude - 0.005,
                    longitude: coordinate.longitude
                ),
                distance: 5000,
                heading: 0,
                pitch: 0
            )
        )
    }
    
    static func getAddress(for location: CLLocation) async -> Result<MKMapItem, Error> {
        let request = MKReverseGeocodingRequest(location: location)
        
        var result: MKMapItem
        
        do {
            let response = try await request?.mapItems
            guard let placemark = response?.first else {
                fatalError("No placemark found")
            }
            
            result = placemark
            
        } catch {
            return Result.failure(error)
        }
        
        return Result.success(result)
    }
}
