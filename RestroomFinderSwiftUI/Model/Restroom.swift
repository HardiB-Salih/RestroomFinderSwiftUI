//
//  Restroom.swift
//  RestroomFinderSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation
import CoreLocation
import MapKit

struct Restroom: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let street: String
    let city: String
    let state: String
    let accessible: Bool
    let unisex: Bool
    let directions: String
    let comment: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    let downvote: Int
    let upvote: Int
    let country: String
    let changingTable: Bool
    let editId: Int
    let approved: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case street
        case city
        case state
        case accessible
        case unisex
        case directions
        case comment
        case latitude
        case longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case downvote
        case upvote
        case country
        case changingTable = "changing_table"
        case editId = "edit_id"
        case approved
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var address: String {
        return "\(street), \(city), \(state), \(country)"
    }
    
}

extension Restroom {
    var mapItem: MKMapItem {
        return createMapItem(
            latitude: latitude,
            longitude: longitude,
            name: name,
            street: street,
            city: city,
            state: state,
            zip: "",
            country: country
        )
    }
}

extension Restroom {
    static let placeholders : [Restroom] = JSONHelper.load("restrooms.json")
    static func placeholder(_ index: Int = 0) -> Restroom {
        return placeholders[index]
    }
}
