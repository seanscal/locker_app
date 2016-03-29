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
    
}
