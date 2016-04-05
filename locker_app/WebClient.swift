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
                            completion: (json: JSON) -> Void,
                            failure: (error: NSError) -> Void)
    {
        WebClient.get(method, parameters:[:], completion: completion, failure: failure)
    }
    
    private static func get(method: String,
                    var parameters: Dictionary<String, AnyObject>,
                    completion: (json: JSON) -> Void,
                    failure: (error: NSError) -> Void)
    {
    
        // send userId with all requests
        parameters["userId"] = 0 //UserSettings.currentUser.userId!
        
        Alamofire.request(.GET, kLockrAPI + method, parameters: parameters)
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
    
    private static func post(method: String,
                             var parameters: Dictionary<String, AnyObject>,
                             completion: (json: JSON) -> Void,
                             failure: (error: NSError) -> Void)
    {
        
        // send userId with all requests
        parameters["userId"] = 0 //UserSettings.currentUser.userId!
        
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
  
  private static func put(method: String, parameters: Dictionary<String, AnyObject>, completion: (json: JSON) -> Void,
    failure: (error: NSError) -> Void)
    {
      Alamofire.request(.PUT, kLockrAPI + method, parameters: parameters)
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
  
    private static func post(method: String, parameters: Dictionary<String, AnyObject>)
    {
      Alamofire.request(.POST, kLockrAPI + method, parameters: parameters)
    }
  
    static func getAllHubs(completion: (response: Array<AnyObject>) -> Void, failure: (error: NSError) -> Void)
    {
        get(WebUtils.kApiMethodHubs, completion: { (json) -> Void in
            completion(response: json.object as! Array<AnyObject>)
            }) { (error) -> Void in
                failure(error: error)
            }
    }
    
    static func getHubInfo(hubId: Int, completion: (response: Dictionary<String, AnyObject>) -> Void)
    {
        get(WebUtils.kApiMethodHubs + "/" + String(hubId), completion: { (json) -> Void in
            completion(response: json.object as! Dictionary<String, AnyObject>)
        }) { (error) -> Void in
            //TODO: handle error
        }
    }
    
    static func makeReservation(hubId: Int, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
    {
        post(WebUtils.kApiMethodReserve, parameters: ["hubId" : hubId], completion: { (json) -> Void in
                completion(response: json.object as! Dictionary<String, AnyObject>)
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    static func beginRental(uid: String?, hubId: Int, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
    {
        post(WebUtils.kApiMethodRent, parameters: ["uid" : uid == nil ? "gb5fhv" : uid!, "hubId" : hubId], completion: { (json) -> Void in
                completion(response: json.object as! Dictionary<String, AnyObject>)
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    static func endRental(uid: String, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
    {
        post(WebUtils.kApiMethodCheckOut, parameters: ["uid" : uid], completion: { (json) -> Void in
            completion(response: json.object as! Dictionary<String, AnyObject>)
            }) { (error) -> Void in
                failure(error: error)
        }
    }
    
    static func unlockLocker(hubId: Int, lockerId: Int, completion: (response: String) -> Void, failure: (error: NSError) -> Void) {
        get(WebUtils.kApiMethodUnlock, parameters: ["locker_id" : lockerId, "hub_id" : hubId], completion: { (json) -> Void in
            completion(response: json.object as! String)
            }) { (error) -> Void in
                failure(error: error)
        }
    }
  
  static func sendUserData(params: Dictionary<String, AnyObject>, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
  {
    post(WebUtils.kApiMethodUsers, parameters: params,
      completion: { (json) -> Void in
        completion(response: json.object as! Dictionary<String, AnyObject>)
      }) { (error) -> Void in
        failure(error: error)
    }
  }
  
  static func updatePIN(params: Dictionary<String, AnyObject>, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
  {
    put(WebUtils.kApiMethodUsers, parameters: params,
      completion: { (json) -> Void in
        completion(response: json.object as! Dictionary<String, AnyObject>)
      }) { (error) -> Void in
        failure(error: error)
    }
  }

  static func updateUser(params: Dictionary<String, AnyObject>, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void)
  {
      put(WebUtils.kApiMethodUsers, parameters: params,
          completion: { (json) -> Void in
              completion(response: json.object as! Dictionary<String, AnyObject>)
      }) { (error) -> Void in
          failure(error: error)
      }
  }
    
  static func getUserByID(id: String, completion: (response: Dictionary<String, AnyObject>) -> Void, failure: (error: NSError) -> Void) {
      get(WebUtils.kApiMethodUsers + "/" + id,
          completion: { (json) -> Void in
              completion(response: json.object as! Dictionary<String, AnyObject>)
      }) { (error) -> Void in
          failure(error: error)
      }
  }

static func getRentalsForUser(active: Bool, completion: (response: Array<AnyObject>) -> Void, failure: (error: NSError) -> Void) {
        get(WebUtils.kApiMethodRentals + "/" + (active ? "1" : "0") + "/" + String(UserSettings.currentUser.userId),
            completion: { (json) -> Void in
                completion(response: json.object as! Array<AnyObject>)
            }) { (error) -> Void in
                failure(error: error)
            }
    }
  }

