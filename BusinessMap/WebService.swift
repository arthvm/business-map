//
//  WebService.swift
//  BusinessMap
//
//  Created by Arthur Mariano on 13/08/25.
//

import Foundation

protocol WebServicing {
	func downloadData<T: Decodable>(fromURL: String) async throws -> T
}

final class WebService: WebServicing {
	func downloadData<T: Decodable>(fromURL: String) async throws -> T {
		guard let url = URL(string: fromURL) else { throw NetworkError.badUrl }
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse else { throw NetworkError.badResponse }
		
		guard response.statusCode >= 200 && response.statusCode < 300 else { throw NetworkError.badStatus }
		guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else { throw NetworkError.failedToDecode }
		
		return decodedResponse
	}
}
