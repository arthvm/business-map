//
//  ContentView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var contactsStore: ContactsStore
    enum SheetDetent: CaseIterable {
        case medium, large
        
        var presentationDetent: PresentationDetent {
            switch self {
            case .medium:
                return .medium
            case .large:
                return .large
            }
        }
        
        static func from(_ pd: PresentationDetent) -> Self {
            switch pd {
            case .medium: return .medium
            case .large: return .large
            default : return .medium
            }
        }
    }

    @State private var contactSearch = ""
    @State private var sheetDetent: SheetDetent = .medium
    
    var body: some View {
        MapView()
            .sheet(isPresented: .constant(true)) {
            NavigationView {
                ContactsListView(searchText: $contactSearch) { searching in
                    sheetDetent = searching ? .large : .medium
                }
                    .searchable(
                        text: $contactSearch,
                        placement: .navigationBarDrawer(displayMode: .automatic)
                    )
            }
            .presentationDetents(
                Set(SheetDetent.allCases.map { $0.presentationDetent }),
                selection: Binding(
                    get: { sheetDetent.presentationDetent },
                    set: { newDetent in
                        sheetDetent = .from(newDetent)
                    }
                )
            )
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
            .sheet(item: $contactsStore.selectedContact) { contact in
                NavigationView {
                    ContactDetailView(contact: contact)
                }
                .presentationDetents(
                    Set(SheetDetent.allCases.map { $0.presentationDetent }),
                    selection: Binding(
                        get: { sheetDetent.presentationDetent },
                        set: { newDetent in
                            sheetDetent = .from(newDetent)
                        }
                    )
                )
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled)
                .interactiveDismissDisabled()
            }
        }
        .task {
            if contactsStore.contacts.isEmpty {
                await contactsStore.fetchData()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ContactsStore(webService: WebService()))
        .environmentObject(LocationStore())
}
