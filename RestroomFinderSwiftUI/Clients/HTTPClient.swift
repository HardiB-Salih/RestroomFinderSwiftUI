//
//  HTTPClient.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation
protocol HTTPClient {
    func fetchRestrooms(url: URL) async throws -> [Restroom]
}
