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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contactsVM)
                .environmentObject(sheetVM)
        }
    }
}
