//
//  BusinessMapApp.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

@main
struct BusinessMapApp: App {
    @StateObject private var contactsStore: ContactsStore
    @StateObject private var locationStore: LocationStore
    
    init() {
        let webService = WebService()
        let contactsStore = ContactsStore(webService: webService)
        let locationStore = LocationStore()
        _contactsStore = StateObject(wrappedValue: contactsStore)
        _locationStore = StateObject(wrappedValue: locationStore)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contactsStore)
                .environmentObject(locationStore)
        }
    }
}
