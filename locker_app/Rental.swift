//
//  Rental.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/24/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import ObjectMapper

class Rental : Mappable {
    
    required init?(_ map: Map) {
        
    }
    
    var uid : String?
    var userId : String?
    
    var hubId : Int?
    var hubName : String?
    var lockerId : Int?
    var lat : Double?
    var long : Double?
    
    var checkInTime : NSDate?
    var checkOutTime : NSDate?
    var status : String?
    var baseRate : Double?
    var hourlyRate : Double?
    
    var firedProximityNotif = false
    var firedDurationNotif = false
    
    func mapping(map: Map) {
        uid             <- map["_id"]
        userId          <- map["userId"]
        hubId           <- map["hubId"]
        hubName         <- map["hubName"]
        lockerId        <- map["lockerId"]
        lat             <- map["lat"]
        long            <- map["long"]
        checkInTime     <- (map["checkInTime"], DateTransform())
        checkOutTime    <- (map["checkOutTime"], DateTransform())
        status          <- map["status"]
        baseRate        <- map["baseRate"]
        hourlyRate      <- map["hourlyRate"]
    }
    
    static func fromJSON(json : AnyObject!) -> Rental? {
        return Mapper<Rental>().map(json)
    }
    
    func elapsedTimeString() -> String {
        let unitFlags: NSCalendarUnit = [.Hour, .Minute]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: checkInTime!, toDate: status == "ACTIVE" ? NSDate() : checkOutTime!, options: NSCalendarOptions())
        return String(components.hour) + " hr, " + String(components.minute) + " min"
    }
    
    func runningTotalString() -> String {
        let endDate = status == "ACTIVE" ? NSDate() : checkOutTime!
        let elapsedHours = endDate.timeIntervalSinceDate(checkInTime!) / kSecondsPerHour
        let runningTotal = baseRate! + (hourlyRate! * elapsedHours)
        return String(format:"$%.2f", runningTotal)
    }
    
}
