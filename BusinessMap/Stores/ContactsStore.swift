//
//  ContactsStore.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class ContactsStore: ObservableObject {
    enum LoadState {
        case idle
        case loading
        case success([Contact])
        case failure(Error)
    }

    @Published private(set) var state: LoadState = .idle
    @Published var selectedContact: [Contact]?
    
    var contacts: [Contact]  {
        if case .success(let contacts) = state {
            return contacts
        }
        
        return []
    }
    
    private let webService: WebServicing
    
    init(webService: WebServicing) {
        self.webService = webService
    }
    
    func fetchData() async {
        state = .loading
        do {
            let downloadedData: [Contact] = try await webService.downloadData(fromURL: "https://jsonplaceholder.typicode.com/users")
            
            state = .success(downloadedData)
        } catch {
            state = .failure(error)
        }
    }
}
