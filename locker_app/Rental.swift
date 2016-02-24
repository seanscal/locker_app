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
    var lockerId : Int?
    var checkInTime : NSDate?
    
    func mapping(map: Map) {
        uid             <- map["uid"]
        userId          <- map["userId"]
        hubId           <- map["hubId"]
        lockerId        <- map["lockerId"]
        checkInTime     <- (map["checkInTime"], DateTransform())
    }
    
    static func fromJSON(json : AnyObject!) -> Rental? {
        return Mapper<Rental>().map(json)
    }
}
