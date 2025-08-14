//
//  BusinessMapApp.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

@main
struct BusinessMapApp: App {
    @StateObject private var contactsVM = ContactsViewModel()
    @StateObject private var sheetVM = SheetViewModel()
    @StateObject private var locationVM = LocationViewModel()
    @StateObject private var nearbyContactsVM: NearbyContactsViewModel

    init() {
        let contactsVM = ContactsViewModel()
        let locationVM = LocationViewModel()
        _contactsVM = StateObject(wrappedValue: contactsVM)
        _locationVM = StateObject(wrappedValue: locationVM)
        _sheetVM = StateObject(wrappedValue: SheetViewModel())
        _nearbyContactsVM = StateObject(wrappedValue: NearbyContactsViewModel(contactsVM: contactsVM, locationVM: locationVM))
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contactsVM)
                .environmentObject(sheetVM)
                .environmentObject(locationVM)
                .environmentObject(nearbyContactsVM)
        }
    }
}
