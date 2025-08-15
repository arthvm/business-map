//
//  ContactsListView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var contactsStore: ContactsStore
    
    @Binding var searchText: String
    var onSearchingChange: (Bool) -> Void = { _ in }
    @Environment(\.isSearching) private var searching
    
    let letters = (65...90).map { String(UnicodeScalar($0)!) }
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            contactsStore.contacts
        } else {
            contactsStore.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var sections: [String: [Contact]] {
        Dictionary(
            grouping: filteredContacts,
            by: { String($0.name.prefix(1).uppercased()) }
        )
    }
    
    var body: some View {
        VStack {
            NearbyContactsView()
                .padding()
            
            List(letters, id:\.self) { letter in
                let contactsForLetter = sections[letter] ?? []
                if !contactsForLetter.isEmpty {
                    Section(letter) {
                        ForEach(contactsForLetter) { contact in
                            ContactItemView(contact: contact)
                        }
                    }
                    .sectionIndexLabel(letter)
                } else {
                    Section {
                        
                    }
                    .sectionIndexLabel(letter)
                }
            }
            .animation(.easeInOut, value: searching)
            .scrollContentBackground(.hidden)
        }
        .onChange(of: searching) { prevState, _ in
            onSearchingChange(prevState)
        }
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview("Large") {
    @Previewable @State var searchText: String = ""
    let contactsStore = ContactsStore(webService: WebService())
    let locationStore = LocationStore()
    
    NavigationStack {
        ContactsListView(searchText: $searchText)
            .environmentObject(contactsStore)
            .environmentObject(locationStore)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
            .task {
                await contactsStore.fetchData()
            }
    }
}
