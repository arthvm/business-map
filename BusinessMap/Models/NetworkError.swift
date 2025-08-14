//
//  NetworkError.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecode
}
