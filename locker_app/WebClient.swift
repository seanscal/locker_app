//
//  WebClient.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/25/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Alamofire

class WebClient {

    static let kLockrAPI = "http://nulockerhub.com/api/"
    
    static func get(method: String) {
        WebClient.get(method, parameters:[:])
    }
    
    
    //TODO - fill this out to return useful info
    static func get(method: String, parameters: Dictionary<String, AnyObject>) {
    
        Alamofire.request(.GET, kLockrAPI + method, parameters: parameters)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
    }
    
}
