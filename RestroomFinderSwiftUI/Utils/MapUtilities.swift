//
//  MapUtilities.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/15/24.
//

import Foundation
import MapKit
import Contacts


/**
 Performs a local search for points of interest within a specified region.

 - Parameters:
    - searchTerm: The search term used to query points of interest.
    - visibleRegion: The region within which to search for points of interest.

 - Returns: An array of `MKMapItem` objects representing the search results.

 - Throws: An error if the search request fails.

 - Note: If `visibleRegion` is `nil`, the function returns an empty array.
*/
func performSearch(
    searchTerm: String,
    visibleRegion: MKCoordinateRegion?
) async throws -> [MKMapItem] {
    
    // Create a search request
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTerm
    request.resultTypes = .pointOfInterest
    
    // Ensure the region is provided, else return an empty array
    guard let region = visibleRegion else { return [] }
    request.region = region
    
    // Perform the search
    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    
    // Return the search results
    return response.mapItems
}


/**
 Returns an `MKMapItem` with a specified coordinate and address details.

 - Parameters:
    - latitude: The latitude of the coordinate.
    - longitude: The longitude of the coordinate.
    - name: The name of the location.
    - street: The street address of the location.
    - city: The city of the location.
    - state: The state of the location.
    - zip: The postal code of the location.
    - country: The country of the location.

 - Returns: An `MKMapItem` object with the provided details.
*/
func createMapItem(
    latitude: CLLocationDegrees,
    longitude: CLLocationDegrees,
    name: String,
    street: String,
    city: String,
    state: String,
    zip: String,
    country: String
) -> MKMapItem {
    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    let addressDict: [String: Any] = [
        CNPostalAddressStreetKey: street,
        CNPostalAddressCityKey: city,
        CNPostalAddressStateKey: state,
        CNPostalAddressPostalCodeKey: zip,
        CNPostalAddressCountryKey: country
    ]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = name
    return mapItem
}


/**
 Calculates the distance between two CLLocation objects and returns the result as a Measurement in meters.

 - Parameters:
    - from: The starting CLLocation.
    - to: The destination CLLocation.
 
 - Returns: The distance between the two locations as a Measurement in meters.
 */
func calculateDistance(from: CLLocation, to: CLLocation) -> Measurement<UnitLength> {
    let distanceInMeters = from.distance(from: to) // Calculate distance in meters
    return Measurement(value: distanceInMeters, unit: .meters) // Return the distance as a Measurement in meters
}


/**
 An enumeration representing the sorting order for sorting map items by distance.

 - ascending: Sort the map items in ascending order of distance from the user's current location.
 - descending: Sort the map items in descending order of distance from the user's current location.
 */
enum SortingOrder {
    case ascending
    case descending
}

/**
 Sorts an array of `MKMapItem` objects based on their distance from the user's current location.

 - Parameters:
    - mapItems: An array of `MKMapItem` objects to be sorted.
    - order: The `SortingOrder` specifying whether to sort the items in ascending or descending order of distance from the user's current location.
 
 - Returns: A sorted array of `MKMapItem` objects based on their distance from the user's current location.

 - Note: Ensure that location services are enabled and authorized. If the user's location is not available, the original array of `MKMapItem` objects is returned without sorting.

 - Example Usage:
    ```swift
    let mapItems: [MKMapItem] = [...] // Your array of MKMapItem objects
    let sortedMapItemsAscending = sortMapItemsByDistance(mapItems: mapItems, order: .ascending)
    let sortedMapItemsDescending = sortMapItemsByDistance(mapItems: mapItems, order: .descending)
    ```
 */
func sortMapItemsByDistance(mapItems: [MKMapItem], order: SortingOrder) -> [MKMapItem] {
    guard let userLocation = LocationManager.shared.manager.location else {
        return mapItems
    }
    
    return mapItems.sorted { lhs, rhs in
        guard let lhsLocation = lhs.placemark.location,
              let rhsLocation = rhs.placemark.location else {
            return false
        }
        
        let lhsDistance = userLocation.distance(from: lhsLocation)
        let rhsDistance = userLocation.distance(from: rhsLocation)
        
        switch order {
        case .ascending:
            return lhsDistance < rhsDistance
        case .descending:
            return lhsDistance > rhsDistance
        }
    }
}


/**
 Calculates the driving directions from one location to another asynchronously and returns the first route.

 - Parameters:
    - from: The starting `MKMapItem`.
    - to: The destination `MKMapItem`.
 
 - Returns: The first `MKRoute` if the directions can be calculated, otherwise `nil`.

 - Throws: An error if the directions cannot be calculated.
 
 - Example Usage:
    ```swift
    let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))) // San Francisco
    let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437))) // Los Angeles
    
    Task {
        if let route = await calculateDirections(from: source, to: destination) {
            print("Distance: \(route.distance) meters")
            print("Expected Travel Time: \(route.expectedTravelTime) seconds")
        } else {
            print("Failed to calculate route")
        }
    }
    ```
 */
func calculateDirections(from: MKMapItem, to: MKMapItem) async -> MKRoute? {
    let directionRequest = MKDirections.Request()
    directionRequest.transportType = .automobile
    directionRequest.source = from
    directionRequest.destination = to
    
    let directions = MKDirections(request: directionRequest)
    
    do {
        let response = try await directions.calculate()
        return response.routes.first
    } catch {
        print("Error calculating directions: \(error.localizedDescription)")
        return nil
    }
}



/**
 Retrieves the phone number from an MKMapItem and converts it to a numeric format, if available.

 - Parameter mapItem: The MKMapItem from which to retrieve the phone number.
 - Returns: An optional String containing the numeric phone number, or nil if the phone number is not available or cannot be converted.
 
 - Example:
    ```swift
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)))
    // Assume mapItem.phoneNumber is set somewhere in the app
    if let phoneNumber = getNumericPhoneNumber(from: mapItem) {
        print("Numeric phone number: \(phoneNumber)")
    } else {
        print("Phone number not available or cannot be converted to numeric format.")
    }
    ```
 */
func getNumericPhoneNumber(from mapItem: MKMapItem) -> String? {
    guard let phoneNumber = mapItem.phoneNumber else {
        return nil
    }
    
    // Remove non-numeric characters
    let numericPhoneNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    
    // Check if the resulting string contains only digits
    guard numericPhoneNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil else {
        return nil
    }
    
    return numericPhoneNumber
}

/**
 Initiates a phone call to the given phone number.
 
 - Parameter phoneNumber: The phone number to call.
 */
func makeCall(to phoneNumber: String) {
    guard let url = URL(string: "tel://\(phoneNumber)"),
          UIApplication.shared.canOpenURL(url) else {
        // Show an alert or handle the error appropriately
        print("Cannot make a call to the provided phone number.")
        return
    }
    
    UIApplication.shared.open(url)
}


/**
 Opens the Maps app with the given MKMapItem for navigation.

 - Parameter mapItem: The MKMapItem representing the destination location.
 
 - Example:
    ```swift
    let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    let placemark = MKPlacemark(coordinate: coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = "San Francisco"
    
    takeMeThere(to: mapItem)
    ```
 */
func takeMeThere(to mapItem: MKMapItem) {
    MKMapItem.openMaps(with: [mapItem], launchOptions: [
        MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
    ])
}
