//
//  MKCoordinateRegion.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/15/24.
//

import Foundation
import MapKit


extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        let epsilon = 1e-5 // Adjust epsilon based on your precision needs
        
        let centerEqual = abs(lhs.center.latitude - rhs.center.latitude) < epsilon &&
                          abs(lhs.center.longitude - rhs.center.longitude) < epsilon
        
        let spanEqual = abs(lhs.span.latitudeDelta - rhs.span.latitudeDelta) < epsilon &&
                        abs(lhs.span.longitudeDelta - rhs.span.longitudeDelta) < epsilon
        
        return centerEqual && spanEqual
    }
}
