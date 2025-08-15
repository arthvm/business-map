//
//  ContactItemView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 14/08/25.
//

import SwiftUI
import MapKit

struct ContactItemView: View {
    @State private var contactAddress: MKMapItem?
    var contact: Contact
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.shadow(.inner(radius: 1.25)))
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.orange)
                
                Text(initials(from: contact.name))
                    .bold()
                    .font(.headline)
            }
            
            VStack(alignment: .leading) {
                Text(contact.name)
                    .font(.headline)
                
                if let addressLocation = contactAddress?.address {
                    Text(addressLocation.shortAddress ?? "Unknown address")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                } else {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 16)
                        .redacted(reason: .placeholder)
                }
            }
        }
        .task {
            guard let contactLat = CLLocationDegrees(contact.address.geo.lat) else {
                return
            }
            
            guard let contactLng = CLLocationDegrees(contact.address.geo.lng) else {
                return
            }

            let contactLocation = CLLocation(
                latitude: contactLat,
                longitude: contactLng
            )
            
            do {
                let address = await LocationStore.getAddress(for: contactLocation)
                
                switch address {
                case .success(let address):
                    self.contactAddress = address
                case .failure:
                    break
                }
            }
        }
    }
    
    func initials(from name: String) -> String {
        let words = name
            .split(separator: " ")
            .filter { !$0.isEmpty }
        let initials = words
            .compactMap { $0.first }
            .map { String($0).uppercased() }
        return initials.joined()
    }
}

#Preview {
    let mockContact = Contact(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        address: Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: Address.Geo(lat: "-37.3159", lng: "81.1496")
        ),
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        company: Company(
            name: "Romaguera-Crona",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )
    
    List {
        ContactItemView(contact: mockContact)
    }
}
