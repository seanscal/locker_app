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
        
        for rental in RentalManager.rentals {
            let rentalLocation = CLLocation(latitude: rental.lat!, longitude: rental.long!)
         
            let distanceFromRental = lastLocation?.distanceFromLocation(rentalLocation)
            
            if distanceFromRental > sampleThreshold {
                triggerProximityNotification(rental, distance: distanceFromRental!)
            }
            
        }
        
    }
    
    func triggerProximityNotification(rental: Rental, distance: Double) {
        //ScreenUtils.rootViewController().displayMessage("Reminder!", message: "Don't forget about your rental at "+rental.hubName!+"! You're about "+String(format: "%.2f", distance/1600)+" miles away.")
        
        if true && !rental.firedProximityNotif { //TODO: check if user has proximity notifications enabled
            let notif = UILocalNotification()
            notif.alertTitle = "Lockr rental alert";
            notif.alertBody = "You're now "+String(format: "%.2f", distance/1600)+" miles from your locker hub. Don't forget to check out and claim your belongings!"
            
            NotificationManager.fireNotification(notif)
            rental.firedProximityNotif = true
        }
        
    }
}
