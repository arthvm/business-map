//
//  MapView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var contactsVM: ContactsViewModel
    @EnvironmentObject var mapVM: LocationViewModel
    
    var body: some View {
        Map(position: $mapVM.cameraPosition) {
            ForEach(contactsVM.contacts) { contact in
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
    @Previewable @StateObject var contactsVM: ContactsViewModel = .init()
    @Previewable @StateObject var mapVM: LocationViewModel = .init()

    MapView()
        .environmentObject(contactsVM)
        .environmentObject(mapVM)
}
