//
//  LockerHub.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/27/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import ObjectMapper

class LockerHub : NSObject, Mappable {
    
    var uid: Int?
    var name: String?
    var openUnits: Int?
    var totalUnits: Int?
    var lat: Double?
    var long: Double?
    
    var baseRate: Double?
    var hourlyRate: Double?
    
    override init() {
        super.init()
    }
    
    convenience init(rental: Rental) {
        self.init()
        
        uid = rental.hubId
        name = rental.hubName
        lat = rental.lat
        long = rental.long
        baseRate = rental.baseRate
        hourlyRate = rental.hourlyRate

    }
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        uid         <- map["_id"]
        name        <- map["name"]
        openUnits   <- map["openUnits"]
        totalUnits  <- map["totalUnits"]
        lat         <- map["lat"]
        long        <- map["long"]
        baseRate    <- map["baseRate"]
        hourlyRate  <- map["hourlyRate"]
    }
    
    func availabilityString() -> String {
        return String(openUnits!) + " open units"
    }
    
    static func fromJSON(json : AnyObject!) -> LockerHub? {
        return Mapper<LockerHub>().map(json)
    }
    
}
