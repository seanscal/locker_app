//
//  LocationManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 3/28/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import CoreLocation

let kLocationUpdateThreshold        = 10.0      // NOT EDITABLE - only receive location updates of intervals > 10 meters
let kRentalDistanceAlertThreshold   = 32186.9   // NOT EDITABLE - threshold beyond which users cannot rent or reserve a locker without a warning
let kMetersPerMile                  = 1609.34

class LocationManager : NSObject, CLLocationManagerDelegate {

    let sampleThreshold : Double = kMetersPerMile // notify user when 1 mile from rental
    
    var manager = CLLocationManager()
    
    struct Static {
        static var lastLocation: CLLocation?
        static var lastRentalPull : NSDate = NSDate(timeIntervalSince1970: 0) // track last rental pull to rate limit to 1/min
    }
    
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
            manager.distanceFilter = kLocationUpdateThreshold
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Static.lastLocation = locations.last
        
        // rate limit rental pulls to 1/minute
        if NSDate().timeIntervalSinceDate(Static.lastRentalPull) < 60 {
            return
        }
        
        RentalManager.getRentalsForUser(true, completion: { (rentals) -> Void in
            
            Static.lastRentalPull = NSDate()
            
            for rental in rentals {
                if rental.status == .Active {
                    let rentalLocation = CLLocation(latitude: rental.lat!, longitude: rental.long!)
                    
                    let distanceFromRental = Static.lastLocation?.distanceFromLocation(rentalLocation)
                    
                    if distanceFromRental > self.sampleThreshold {
                        self.triggerProximityNotification(rental, distance: distanceFromRental!)
                    }
                }
            }
            
            }) { (error) -> Void in
                // ignore
        }
        
    }
    
    func triggerProximityNotification(rental: Rental, distance: Double) {
        
        if true && !rental.firedProximityNotif { //TODO: check if user has proximity notifications enabled
            let notif = UILocalNotification()
            notif.alertTitle = "Lockr rental alert";
            notif.alertBody = "You're now "+String(format: "%.2f", distance/kMetersPerMile)+" miles from your locker hub. Don't forget to check out and claim your belongings!"
            
            NotificationManager.fireNotification(notif)
            WebClient.firedNotif(rental.uid!, type: .Proximity, completion: { (response) -> Void in
                //nada
                }, failure: { (error) -> Void in
                    //nada
            })
        }
        
    }
    
    static func userLocation() -> CLLocation? {
        return Static.lastLocation
    }
    
    static func prepareForPull() {
        Static.lastRentalPull = NSDate(timeIntervalSince1970: 0)
    }
}
