//
//  NotificationManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 3/28/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

let kMinuteThreshold : Double = 1

class NotificationManager: NSObject {
    
    static var lastNotifTime = NSDate(timeIntervalSince1970: 0)
    
    override init() {
        super.init()
        
        let settings = UIUserNotificationSettings(forTypes: [.Badge, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getExpirationNotifs", userInfo: nil, repeats: true)
    }
    
    static func fireNotification(notification: UILocalNotification) {
        
        // calculate elapsed time since last notification
        let minutesSinceLastNotif = NSDate().timeIntervalSinceDate(lastNotifTime) / Double(60)
        
        // only proceed if minute threshold is surpassed
        if minutesSinceLastNotif > kMinuteThreshold {
            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
            lastNotifTime = NSDate()
        }
        
    }
    
    func getExpirationNotifs() {
        WebClient.getExpirationNotifs({ (response) -> Void in
            for jsonRental in response {
                if let rental = Rental.fromJSON(jsonRental) {
                    let notification = UILocalNotification()
                    notification.alertTitle = "Reservation Expired"
                    notification.alertBody = String(format: "Your reservation at @% has expired.", rental.hubName!)
                    
                    NotificationManager.fireNotification(notification)
                    
                    WebClient.firedNotif(rental.uid!, type: .Expiration, completion: { (response) -> Void in
                        print("Successfully notified server of notification.")
                        }, failure: { (error) -> Void in
                            print("Error notifying server of notification.")
                    })
                    
                }
            }
            }) { (error) -> Void in
                // silently fail
                print("Error fetching expiration notifs.")
        }
    }
    
}
