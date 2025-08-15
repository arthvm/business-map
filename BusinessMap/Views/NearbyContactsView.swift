//
//  NearbyContactsView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 14/08/25.
//

import SwiftUI
import MapKit

struct NearbyContactsView: View {
    @EnvironmentObject var locationStore: LocationStore
    @EnvironmentObject var contactsStore: ContactsStore
    
    var nearbyContacts: [Contact] {
        guard let userCoord = locationStore.userLocation else { return [] }
        let userLocation = CLLocation(latitude: userCoord.latitude, longitude: userCoord.longitude)
        return contactsStore.contacts
            .sorted {
                let lhs = CLLocation(
                    latitude: CLongDouble($0.address.geo.lat) ?? 0,
                    longitude: CLongDouble($0.address.geo.lng) ?? 0
                )
                let rhs = CLLocation(
                    latitude: CLongDouble($1.address.geo.lat) ?? 0,
                    longitude: CLongDouble($1.address.geo.lng) ?? 0
                )
                return lhs.distance(from: userLocation) < rhs.distance(from: userLocation)
            }
            .prefix(3)
            .map { $0 }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Nearby")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            
            if nearbyContacts.isEmpty {
                HStack {
                    Spacer()
                    Text("No contacts nearby")
                    Spacer()
                }
                .padding(36)
                .font(.callout)
                .foregroundStyle(.secondary)
            } else {
                HStack(spacing: 16) {
                    ForEach(nearbyContacts) { contact in
                        Button {
                            guard let lat = Double(contact.address.geo.lat),
                                  let lng = Double(contact.address.geo.lng) else { return }
                            let contactCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            locationStore.centerMap(on: contactCoord)
                            contactsStore.selectedContact = contact
                        } label: {
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .frame(width: 80, height: 80)
                                        .foregroundStyle(.blue)
                                        .opacity(0.3)
                                    
                                    Image(systemName: "person.fill")
                                        .foregroundStyle(.blue)
                                        .font(.largeTitle)
                                }
                                
                                Text(contact.name)
                                    .frame(maxWidth: 80)
                                    .truncationMode(.tail)
                                    .lineLimit(1)
                                    .foregroundStyle(.white)
                                    .font(.caption)
                                    .bold()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var contactsStore = ContactsStore(webService: WebService())
    @Previewable @StateObject var locationStore = LocationStore()
    
    NearbyContactsView()
        .environmentObject(contactsStore)
        .environmentObject(locationStore)
}
