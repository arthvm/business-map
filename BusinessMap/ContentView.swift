//
//  ContentView.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showSheet = true
    @State private var detention: PresentationDetent = .third
    @State private var contactSearch = ""
    
    var body: some View {
        MapView()
        .ignoresSafeArea()
        .sheet(isPresented: $showSheet) {
            NavigationView {
                ContactsListView(searchText: $contactSearch, sheetDetent: $detention)
                    .searchable(
                        text: $contactSearch,
                        placement: .navigationBarDrawer(displayMode: .automatic)
                    )
            }
            .presentationDetents([.third, .large], selection: $detention)
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .interactiveDismissDisabled()
        }
    }
}


extension PresentationDetent {
    static var third: PresentationDetent {
        .fraction(0.33)
    }
}

#Preview {
    ContentView()
}
