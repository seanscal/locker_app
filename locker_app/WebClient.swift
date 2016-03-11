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
    
    private static func get(method: String,
                    completion: (json: JSON) -> Void)
    {
        WebClient.get(method, parameters:[:], completion: completion)
    }
    
    private static func get(method: String,
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
    
    private static func post(method: String,
                             parameters: Dictionary<String, AnyObject>,
                             completion: (json: JSON) -> Void,
                             failure: (error: NSError) -> Void)
    {
        Alamofire.request(.POST, kLockrAPI + method, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        completion(json: json)
                    }
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }
    
    static func getAllHubs(completion: (response: Array<AnyObject>) -> Void)
    {
        get(WebUtils.kApiMethodHubs) { (json) -> Void in
            completion(response: json.object as! Array<AnyObject>)
        }
    }
    
    static func getHubInfo(hubId: Int, completion: (response: Dictionary<String, AnyObject>) -> Void)
    {
        get(WebUtils.kApiMethodHubs + "/" + String(hubId)) { (json) -> Void in
            completion(response: json.object as! Dictionary<String, AnyObject>)
        }
    }
    
    static func makeReservation(hubId: Int, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
    {
        post(WebUtils.kApiMethodReserve, parameters: ["locker_id" : hubId, "customer_id" : UserSettings.userId], completion: { (json) -> Void in
                completion(response: json.object as! Dictionary<String, AnyObject>)
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
}
