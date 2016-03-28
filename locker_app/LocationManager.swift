//
//  LocationManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 3/28/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {

    let sampleLocation = CLLocation(latitude: 42.34, longitude: -71.09)
    let sampleThreshold : Double = 1600 // notify user when 1600+ meters from rental (~1 mi)
    
    var manager = CLLocationManager()
    
    override init() {
        
        super.init()
        
        // request location for new users
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestAlwaysAuthorization()
        }
        
        // set delegate
        manager.delegate = self
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last
        
        let distanceFromRental = lastLocation?.distanceFromLocation(sampleLocation)
        
        if distanceFromRental > sampleThreshold {
            UIApplication.sharedApplication().keyWindow?.rootViewController?.displayMessage("Location Update", message: "You are "+String(distanceFromRental!/1600)+" miles from the marker.")
        }
        
    }
}
