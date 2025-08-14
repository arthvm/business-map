//
//  ContactsListView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContactsListView: View {
    @EnvironmentObject var contactsVM: ContactsViewModel
    @EnvironmentObject var sheetVM: SheetViewModel
    
    @Binding var searchText: String
    @Environment(\.isSearching) private var searching
    
    let letters = (65...90).map { String(UnicodeScalar($0)!) }
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            contactsVM.contacts
        } else {
            contactsVM.contacts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
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
            switch sheetVM.detent {
            case .medium:
                ForEach( filteredContacts) { contact in
                    Text(contact.name)
                }
            default:
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
        .animation(.easeInOut, value: sheetVM.detent)
        .scrollContentBackground(.hidden)
        .onChange(of: searching) {
            if searching {
                sheetVM.setDetent(.large)
            } else {
                sheetVM.setDetent(.medium)
            }
        }
        .navigationTitle("Contacts")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Large") {
    @Previewable @State var searchText: String = ""
    
    @Previewable @StateObject var sheetVM = SheetViewModel.preview(withDetent: .large)
    @Previewable @StateObject var contactsVM = ContactsViewModel()
    
    NavigationStack {
        ContactsListView(searchText: $searchText)
            .environmentObject(sheetVM)
            .environmentObject(contactsVM)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
    }
}

#Preview("Medium") {
    @Previewable @State var searchText: String = ""
    
    @Previewable @StateObject var sheetVM = SheetViewModel.preview(withDetent: .medium)
    @Previewable @StateObject var contactsVM = ContactsViewModel()
    
    NavigationStack {
        ContactsListView(searchText: $searchText)
            .environmentObject(sheetVM)
            .environmentObject(contactsVM)
            .searchable(
                text: $searchText,
                placement: .navigationBarDrawer(displayMode: .automatic)
            )
    }
}
