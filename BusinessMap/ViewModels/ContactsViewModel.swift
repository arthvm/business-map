//
//  ContactsViewModel.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation
import Combine
import CoreLocation

@MainActor
class ContactsViewModel: ObservableObject {
    enum LoadState {
        case idle
        case loading
        case success([Contact])
        case failure(Error)
    }

    @Published private(set) var state: LoadState = .idle
    
    var contacts: [Contact]  {
        if case .success(let contacts) = state {
            return contacts
        }
        
        return []
    }
    
    init() {
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        state = .loading
        do {
            let downloadedData: [Contact] = try await WebService().downloadData(fromURL: "https://jsonplaceholder.typicode.com/users")
            
            state = .success(downloadedData)
        } catch {
            state = .failure(error)
        }
    }
}
