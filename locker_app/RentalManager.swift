//
//  RentalManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/24/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class RentalManager {
    
    static func checkForActiveRental(hubId : Int, completion: (rental: Rental) -> Void) {
        WebClient.getRentalsForUser(true) { (response) -> Void in
            for jsonRental in response {
                let rental = Rental.fromJSON(jsonRental)
                if rental!.hubId == hubId {
                    completion(rental: rental!)
                }
            }
        }
    }
}
