//
//  RestroomClient.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation

struct RestroomClient: HTTPClient {
    
    
    private enum RestroomClientError: Error {
        case invalidResponse
        case networkError(Error)
    }
    
    
    func fetchRestrooms(url: URL) async throws -> [Restroom] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw RestroomClientError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode([Restroom].self, from: data)
        } catch {
            throw RestroomClientError.networkError(error)
        }
    }
}

