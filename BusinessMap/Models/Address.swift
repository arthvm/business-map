//
//  Address.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation

struct Address: Codable {
    var street: String
    var suite: String
    var city: String
    var zipcode: String
    var geo: Geo
    
    struct Geo: Codable {
        var lat: String
        var lng: String
    }
}
