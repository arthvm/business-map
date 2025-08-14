//
//  ContactsViewModel.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation
import Combine

@MainActor
class ContactsViewModel: ObservableObject {
    @Published var contacts = [Contact]()
    
    func fetchData() async {
        guard let dowloadedData: [Contact] = await WebService().downloadData(fromURL: "https://jsonplaceholder.typicode.com/users") else {
            return
        }
        
        contacts = dowloadedData
        
        return
    }
}
