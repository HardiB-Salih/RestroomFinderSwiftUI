//
//  MKMapItem.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/16/24.
//

import Foundation
import MapKit
import Contacts

extension MKMapItem {
    /**
     A computed property that returns the address of the `MKMapItem` as a string.

     Example
     ```swift
        let mapItem: MKMapItem = // Your MKMapItem instance
        let address = mapItem.address
        print(address)
     ```
     - Returns: A string representing the address of the `MKMapItem`. If any component of the address is `nil`, it will be replaced with an empty string.
     */
    var address: String {
        let placemark = self.placemark
        let thoroughfare = placemark.thoroughfare ?? ""
        let subThoroughfare = placemark.subThoroughfare ?? ""
        let locality = placemark.locality ?? ""
        let subLocality = placemark.subLocality ?? ""
        let administrativeArea = placemark.administrativeArea ?? ""
        let postalCode = placemark.postalCode ?? ""
        let country = placemark.country ?? ""
        
        return "\(subThoroughfare) \(thoroughfare), \(subLocality), \(locality), \(administrativeArea) \(postalCode), \(country)"
    }
    
    
    
    
    
   
    
    static var placeholder : MKMapItem = createMapItem(
        latitude: 37.7749,
        longitude: -122.4194,
        name: "Apple Store",
        street: "1 Infinite Loop",
        city: "Cupertino",
        state: "CA",
        zip: "95014",
        country: "USA"
    )
}







//
//{
//    isCurrentLocation = 0;
//    name = "Shell AutoGas - Arasda Akaryak\U0131t";
//    placemark = "Shell AutoGas - Arasda Akaryak\U0131t, Karadere Cd. 86, 14300 Bolu Merkez Bolu, T\U00fcrkiye @ <+40.75058800,+31.62918200> +/- 0.00m, region CLCircularRegion (identifier:'<+40.75058801,+31.62918200> radius 141.17', center:<+40.75058801,+31.62918200>, radius:141.17m)";
//    timeZone = "Europe/Istanbul (GMT+3) offset 10800";
//    url = "http://www.shell.com.tr";
//}
