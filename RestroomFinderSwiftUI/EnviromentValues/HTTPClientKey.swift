//
//  HTTPClientKey.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation
import SwiftUI

private struct HTTPClientKey: EnvironmentKey {
    static var defaultValue: HTTPClient = RestroomClient()
}

extension EnvironmentValues {
    var httpClient: HTTPClient {
        get {  self[HTTPClientKey.self] }
        set {  self[HTTPClientKey.self] = newValue }
    }
}
