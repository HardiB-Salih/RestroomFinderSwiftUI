//
//  LocationManager.swift
//  NearMeSwiftUI
//
//  Created by HardiB.Salih on 6/15/24.
//

import Foundation
import MapKit
import Observation


@Observable
class LocationManager: NSObject {
    let manager = CLLocationManager()
    static let shared = LocationManager()
    
    var mylocation : CLLocation = CLLocation()
    var region : MKCoordinateRegion = MKCoordinateRegion()
    var error: LocationError? = nil
    
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
    
}


//MARK: -CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map { location in
            mylocation = location
            
            let center = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            region = MKCoordinateRegion(center: center, span: .span)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.requestAlwaysAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .restricted:
            error = .authorizationRestricted
        case .denied:
            error = .authorizationDenied
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        if let clError = error as? CLError {
            switch clError.code {
            case .locationUnknown:
                self.error = .unknownLocation
            case .network:
                self.error = .network
            case .denied:
                self.error = .accessDenied
                // Optionally stop location updates to prevent further errors
                manager.stopUpdatingLocation()
            case .headingFailure:
                self.error = .headingFailure
            case .regionMonitoringDenied:
                self.error = .regionMonitoringDenied
            case .regionMonitoringFailure:
                self.error = .regionMonitoringFailure
            case .regionMonitoringSetupDelayed:
                self.error = .regionMonitoringSetupDelayed
            case .regionMonitoringResponseDelayed:
                self.error = .regionMonitoringResponseDelayed
            case .deferredFailed:
                self.error = .deferredFailed
            case .deferredNotUpdatingLocation:
                self.error = .deferredNotUpdatingLocation
            case .deferredAccuracyTooLow:
                self.error = .deferredAccuracyTooLow
            case .deferredDistanceFiltered:
                self.error = .deferredDistanceFiltered
            case .deferredCanceled:
                self.error = .deferredCanceled
            default:
                self.error = .unknown(clError.localizedDescription)
                
            }
        }
    }
}


//MARK: -LocationError
enum LocationError: LocalizedError {
    case authorizationDenied
    case authorizationRestricted
    case unknownLocation
    case accessDenied
    case operationFailed
    case locationUnknown
    case denied
    case network
    case headingFailure
    case regionMonitoringDenied
    case regionMonitoringFailure
    case regionMonitoringSetupDelayed
    case regionMonitoringResponseDelayed
    case deferredFailed
    case deferredNotUpdatingLocation
    case deferredAccuracyTooLow
    case deferredDistanceFiltered
    case deferredCanceled
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .authorizationDenied:
            return NSLocalizedString("Location access denied.", comment: "")
        case .authorizationRestricted:
            return NSLocalizedString("Location access restricted.", comment: "")
        case .unknownLocation:
            return NSLocalizedString("Unknown location.", comment: "")
        case .accessDenied:
            return NSLocalizedString("Access denied.", comment: "")
        case .operationFailed:
            return NSLocalizedString("Operation failed.", comment: "")
        case .locationUnknown:
            return NSLocalizedString("The location is currently unknown, but will be updated shortly.", comment: "")
        case .denied:
            return NSLocalizedString("Access to location services was denied by the user.", comment: "")
        case .network:
            return NSLocalizedString("The network is unavailable or a network error occurred.", comment: "")
        case .headingFailure:
            return NSLocalizedString("The heading could not be determined.", comment: "")
        case .regionMonitoringDenied:
            return NSLocalizedString("Region monitoring is denied.", comment: "")
        case .regionMonitoringFailure:
            return NSLocalizedString("A region monitoring error occurred.", comment: "")
        case .regionMonitoringSetupDelayed:
            return NSLocalizedString("Region monitoring setup was delayed.", comment: "")
        case .regionMonitoringResponseDelayed:
            return NSLocalizedString("The response to a region monitoring event was delayed.", comment: "")
        case .deferredFailed:
            return NSLocalizedString("Deferred mode failed.", comment: "")
        case .deferredNotUpdatingLocation:
            return NSLocalizedString("Deferred mode failed because location updates were disabled.", comment: "")
        case .deferredAccuracyTooLow:
            return NSLocalizedString("Deferred mode failed because the desired accuracy could not be achieved.", comment: "")
        case .deferredDistanceFiltered:
            return NSLocalizedString("Deferred mode failed because updates were deferred beyond the distance filter.", comment: "")
        case .deferredCanceled:
            return NSLocalizedString("Deferred mode was canceled.", comment: "")
        case .unknown(let description):
            return "An unknown error occurred: \(description)"
        }
    }
}


//MARK: -MKCoordinateSpan
extension MKCoordinateSpan {
    static var span : MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
}
