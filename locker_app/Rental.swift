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
    
    var uid : Int?
    var userId : Int?
    
    var hubId : Int?
    var hubName : String?
    var lockerId : Int?
    var lat : Double?
    var long : Double?
    
    var checkInTime : NSDate?
    var checkOutTime : NSDate?
    var isActive : Bool?
    var baseRate : Double?
    var hourlyRate : Double?
    
    func mapping(map: Map) {
        uid             <- map["uid"]
        userId          <- map["userId"]
        hubId           <- map["hubId"]
        hubName         <- map["hubName"]
        lockerId        <- map["lockerId"]
        lat             <- map["lat"]
        long            <- map["long"]
        checkInTime     <- (map["checkInTime"], DateTransform())
        checkOutTime    <- (map["checkOutTime"], DateTransform())
        isActive        <- map["isActive"]
        baseRate        <- map["baseRate"]
        hourlyRate      <- map["hourlyRate"]
    }
    
    static func fromJSON(json : AnyObject!) -> Rental? {
        return Mapper<Rental>().map(json)
    }
    
    func elapsedTimeString() -> String {
        let unitFlags: NSCalendarUnit = [.Hour, .Minute]
        let components = NSCalendar.currentCalendar().components(unitFlags, fromDate: checkInTime!, toDate: isActive == true ? NSDate() : checkOutTime!, options: NSCalendarOptions())
        return String(components.hour) + " hr, " + String(components.minute) + " min"
    }
    
    func runningTotalString() -> String {
        let endDate = isActive == true ? NSDate() : checkOutTime!
        let elapsedHours = endDate.timeIntervalSinceDate(checkInTime!) / kSecondsPerHour
        let runningTotal = baseRate! + (hourlyRate! * elapsedHours)
        return String(format:"$%.2f", runningTotal)
    }
    
}
