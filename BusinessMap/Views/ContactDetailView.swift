//
//  ContactDetailView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 15/08/25.
//

import SwiftUI
import MapKit

struct ContactDetailView: View {
    enum ViewState {
        case hidden, visible(Contact)
    }
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var locationStore: LocationStore
    var contact: Contact?
    
    var viewState: ViewState {
        guard let contact else { return .hidden }
        return .visible(contact)
    }
    
    var body: some View {
        switch viewState {
            case .hidden:
            EmptyView()
        case .visible(let contact):
            VStack {
                HStack {
                    ContactButtonView(
                        text: "Mail",
                        systemImage: "tray.fill",
                        disabled: contact.email == ""
                    ) {
                        openMail(emailTo: contact.email)
                    }
                    
                    ContactButtonView(
                        text: "Call",
                        systemImage: "phone.fill",
                        disabled: contact.phone == ""
                    ) {
                        openPhone(callTo: contact.phone)
                    }
                    
                    ContactButtonView(
                        text: "Website",
                        systemImage: "safari.fill",
                        disabled: contact.website == ""
                    ) {
                        openWeb(goTo: contact.website)
                    }
                }
                .padding(.horizontal)
                
                List {
                    DetailRowView(title: "Email", value: contact.email)
                    DetailRowView(title: "Phone", value: contact.phone)
                    DetailRowView(title: "Website", value: contact.website)
                    DetailRowView(title: "Address", value: "\(contact.address.street), \(contact.address.suite) \n \(contact.address.city) \n \(contact.address.zipcode)")
                }
                .scrollContentBackground(.hidden)
            }
            .toolbar {
                Button(role: .close) {
                    locationStore.centerMap(on: locationStore.userLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                    dismiss()
                }
            }
            .navigationTitle(contact.name)
            .navigationSubtitle(contact.company.bs)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func openMail(emailTo:String) {
        if let url = URL(string: "mailto:\(emailTo)")
        {
            UIApplication.shared.open(url)
        }
    }
    
    func openPhone(callTo:String) {
        if let url = URL(string: "tel://\(callTo)")
        {
            UIApplication.shared.open(url)
        }
    }
    
    func openWeb(goTo:String) {
        if let url = URL(string: goTo)
        {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    @Previewable @State var mockContact: Contact?
    let contact = Contact(
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

    
    ContactItemView(contact: contact)
        .sheet(item: $mockContact) { contact in
            NavigationView {
                ContactDetailView(contact: contact)
                    .environmentObject(LocationStore())
            }
        }
        .onAppear {
            mockContact = contact
        }
}
