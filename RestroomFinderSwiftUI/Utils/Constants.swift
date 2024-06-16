//
//  Constants.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation

struct Constants {
    struct URLs {
        static func restroomsByLocation(latitude: Double, longitude: Double) -> URL {
            return URL(string: "https://refugerestrooms.org/api/v1/restrooms/by_location?lat=\(latitude)&lng=\(longitude)")!
        }
    }
}
