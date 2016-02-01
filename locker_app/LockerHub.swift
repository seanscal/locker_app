//
//  LockerHub.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/27/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import ObjectMapper

class LockerHub : Mappable {
    
    var name: String?
    var openUnits: Int?
    var lat : Double?
    var long : Double?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        name        <- map["name"]
        openUnits   <- map["openUnits"]
        lat         <- map["lat"]
        long        <- map["long"]
    }
    
    func availabilityString() -> String {
        return String(openUnits!) + " open units"
    }
    
}