//
//  MapView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var contactsStore: ContactsStore
    @EnvironmentObject var mapStore: LocationStore
    
    var body: some View {
        Map(position: $mapStore.cameraPosition) {
            ForEach(contactsStore.contacts) { contact in
                Marker(contact.name, systemImage: "person.fill", coordinate: CLLocationCoordinate2D(
                    latitude: CLongDouble(contact.address.geo.lat) ?? 0,
                    longitude: CLongDouble(contact.address.geo.lng) ?? 0
                ))
            }
            
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
                .safeAreaPadding()
        }
    }
}

#Preview {
    @Previewable @StateObject var contactsStore = ContactsStore(webService: WebService())
    @Previewable @StateObject var mapStore = LocationStore()

    MapView()
        .environmentObject(contactsStore)
        .environmentObject(mapStore)
}
