//
//  Contact.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation

struct Contact: Identifiable, Codable {
    let id: Int
    
    var name: String
    var username: String
    var email: String
    var address: Address
    var phone: String
    var website: String
    var company: Company
}
