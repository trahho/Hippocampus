//
//  LocationService.swift
//  Hippocampus
//
//  Created by Guido Kühn on 30.03.23.
//

import CoreLocation
import Foundation

class LocationService: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    var location: CLLocation? {
        locationManager.location
    }

    var authorization: CLAuthorizationStatus {
        locationManager.authorizationStatus
    }

    func start() {
        if authorization != CLAuthorizationStatus.authorizedAlways { locationManager.requestAlwaysAuthorization() }
        locationManager.startUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_: CLLocationManager) {
        print("\(authorization)")
    }

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
//        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
}
