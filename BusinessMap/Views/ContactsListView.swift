//
//  ContactsListView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContactsListView: View {
    @StateObject private var viewModel = ContactsViewModel()
    
    @Binding var searchText: String
    
    @Environment(\.isSearching) private var searching
    @Binding var sheetDetent: PresentationDetent
    
    let letters = (65...90).map { String(UnicodeScalar($0)!) }

    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            viewModel.contacts
        } else {
            viewModel.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var sections: [String: [String]] {
        Dictionary(
            grouping: filteredContacts.map(\.name),
            by: { String($0.prefix(1).uppercased()) }
        )
    }
    
    var body: some View {
        List(letters, id:\.self) { letter in
            if sheetDetent == .third {
                ForEach( filteredContacts) { contact in
                    Text(contact.name)
                }
            } else {
                if let contactsForLetter = sections[letter], !contactsForLetter.isEmpty {
                    Section(letter) {
                        ForEach(sections[letter] ?? [], id:\.self) { contact in
                            Text(contact)
                        }
                    }
                    .sectionIndexLabel(letter)
                } else {
                    Section {
                        
                    }
                    .sectionIndexLabel(letter)
                }
            }
        }
        .animation(.easeInOut, value: sheetDetent)
        .scrollContentBackground(.hidden)
        .onAppear {
            if viewModel.contacts.isEmpty {
                Task {
                    await viewModel.fetchData()
                }
            }
        }
        .onChange(of: searching) {
            if $1 {
                sheetDetent = .large
            } else {
                sheetDetent = .third
            }
        }
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @State var searchText: String = ""
    
    NavigationStack {
        ContactsListView(searchText: $searchText, sheetDetent: .constant(.large))
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
    }
}
