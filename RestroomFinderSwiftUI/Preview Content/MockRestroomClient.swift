//
//  MockRestroomClient.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation

struct MockRestroomClient : HTTPClient {
    func fetchRestrooms(url: URL) async throws -> [Restroom] {
        return JSONHelper.load("restrooms.json")
    }
    
    
}
