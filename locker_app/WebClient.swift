//
//  WebClient.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/25/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Alamofire
import SwiftyJSON

class WebClient {

    static let kLockrAPI = WebUtils.webApi
    
    static func get(method: String,
                    completion: (json: JSON) -> Void)
    {
        WebClient.get(method, parameters:[:], completion: completion)
    }
    
    static func get(method: String,
                    parameters: Dictionary<String, AnyObject>,
                    completion: (json: JSON) -> Void)
    {
    
        Alamofire.request(.GET, kLockrAPI + method, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                    case .Success:
                        if let value = response.result.value {
                            let json = JSON(value)
                            completion(json: json)
                        }
                    case .Failure(let error):
                        print(error)
                }
        }
        
    }
    
    static func hubs(completion: (response: Array<AnyObject>) -> Void)
    {
        get(WebUtils.kApiMethodHubs) { (json) -> Void in
            completion(response: json.object as! Array<AnyObject>)
        }
    }
    
}
