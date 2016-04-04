//
//  RentalManager.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/24/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class RentalManager {
    
    static var rentals : Array<Rental> = []
    
    static func pull() {
        RentalManager.getRentalsForUser(true, completion: { (rentals) -> Void in
            // completion
            RentalManager.rentals = rentals
            }) { (error) -> Void in
                // failure
                
        }
    }
    
    static func push(rental: Rental) {
        rentals.append(rental)
    }
    
    static func checkForActiveRental(hubId : Int, completion: (rental: Rental) -> Void, failure: (error: NSError) -> Void) {

        WebClient.getRentalsForUser(true,
            completion: { (response) -> Void in
                for jsonRental in response {
                    let rental = Rental.fromJSON(jsonRental)
                    if rental!.hubId == hubId {
                        completion(rental: rental!)
                    }
                }
            }) { (error) -> Void in
                failure(error: error)
            }
    }
    
    static func getRentalsForUser(active: Bool, completion: (rentals: Array<Rental>) -> Void, failure: (error: NSError) -> Void) {
        
        WebClient.getRentalsForUser(active,
            completion: { (response) -> Void in
            
                var rentals: Array<Rental> = []
            
                for jsonRental in response {
                    let rental = Rental.fromJSON(jsonRental)!
                    rentals.append(rental)
                }
            
                completion(rentals: rentals)
                
            }) { (error) -> Void in
                failure(error: error)
            }
    }
}
