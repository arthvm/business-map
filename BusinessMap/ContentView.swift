//
//  ContentView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contactsVM: ContactsViewModel
    @EnvironmentObject var sheetVM: SheetViewModel

    @State private var contactSearch = ""
    
    var body: some View {
        MapView()
        .sheet(isPresented: .constant(true)) {
            NavigationView {
                ContactsListView(searchText: $contactSearch)
                    .searchable(
                        text: $contactSearch,
                        placement: .navigationBarDrawer(displayMode: .automatic)
                    )
            }
            .presentationDetents(
                Set(SheetViewModel.SheetDetent.allCases.map { $0.presentationDetent }),
                selection: Binding(
                    get: { sheetVM.detent.presentationDetent },
                    set: { newDetent in
                        sheetVM.detent = .from(newDetent)
                    }
                )
            )
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    let contactsVM = ContactsViewModel()
    let locationVM = LocationViewModel()
    let sheetVM = SheetViewModel()
    let nearbyVM = NearbyContactsViewModel(
        contactsVM: contactsVM,
        locationVM: locationVM
    )
    
    ContentView()
        .environmentObject(contactsVM)
        .environmentObject(locationVM)
        .environmentObject(sheetVM)
        .environmentObject(nearbyVM)
}
