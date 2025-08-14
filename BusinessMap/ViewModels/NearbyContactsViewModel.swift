//
//  NearbyContactsViewModel.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 14/08/25.
//

import Foundation
import Combine
import CoreLocation

final class NearbyContactsViewModel: ObservableObject {
    @Published private(set) var nearbyContacts = [Contact]()
    
    private var cancellable = Set<AnyCancellable>()
    
    init(contactsVM: ContactsViewModel, locationVM: LocationViewModel) {
        let contactsPublisher = contactsVM.$state
            .map { state -> [Contact] in
                if case .success(let contacts) = state { return contacts }
                return []
            }
            .eraseToAnyPublisher()
        
        Publishers.CombineLatest(contactsPublisher, locationVM.$userLocation)
            .map { contacts, location in
                guard let userCoord = location else { return [] }
                
                let userLocation = CLLocation(
                    latitude: userCoord.latitude,
                    longitude: userCoord.longitude
                )
                
                return contacts
                    .sorted {
                        let lhsDistance = CLLocation(
                            latitude: CLongDouble($0.address.geo.lat) ?? 0,
                            longitude: CLongDouble($0.address.geo.lng) ?? 0
                        )
                        
                        let rhsDistance = CLLocation(
                            latitude: CLongDouble($1.address.geo.lat) ?? 0,
                            longitude: CLongDouble($1.address.geo.lng) ?? 0
                        )
                        
                        return lhsDistance.distance(from: userLocation) < rhsDistance.distance(from: userLocation)
                    }
                    .prefix(3)
                    .map { $0 }
            }
            .assign(to: &$nearbyContacts)
    }
}
