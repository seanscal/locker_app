//
//  RentalManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/24/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class RentalManager {
    
    static func activeRentalAtHub(hubId : Int) -> Rental? {
        if(false){
            return Rental.fromJSON([ "uid" : 1,
                                     "userId" : 1,
                                     "hubId" : 1,
                                     "lockerId" : 6,
                                     "checkInTime" : NSDate().dateByAddingTimeInterval(-2000).timeIntervalSince1970])
        }
        return nil
    }
}
