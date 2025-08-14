//
//  NearbyContactsView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 14/08/25.
//

import SwiftUI
import MapKit

struct NearbyContactsView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    @EnvironmentObject var nearContactsVM: NearbyContactsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Nearby")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            
            if nearContactsVM.nearbyContacts.isEmpty {
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
                    ForEach(nearContactsVM.nearbyContacts) { contact in
                        Button {
                            guard let lat = Double(contact.address.geo.lat),
                                  let lng = Double(contact.address.geo.lng) else { return }
                            let contactCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            locationVM.centerMap(on: contactCoord)
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
    @Previewable @StateObject var nearContactsVM: NearbyContactsViewModel = .init(contactsVM: ContactsViewModel(), locationVM: LocationViewModel())
    @Previewable @StateObject var locationVM: LocationViewModel = .init()
    
    NearbyContactsView()
        .environmentObject(nearContactsVM)
        .environmentObject(locationVM)
}
