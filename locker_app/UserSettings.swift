//
//  UserSettings.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/18/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

let kUserID = "userID"
let kUserName = "userName"
let kUserEmail = "userEmail"
let kUserCards = "userCards"
//userId = 1 // TODO: implement this class
//static let userName = "Test Guy"
//static let userCards = ["Debit", "Credit"]
//static let userEmail = "test.guy@lockr.com"

class UserSettings: NSObject {
    var id: Int!
    var name: String!
    var email: String!
    var cards: [String]!
    
    class var currentUser: UserSettings
    {
        struct Static
        {
            static var instance: UserSettings?
        }
        
        if Static.instance == nil
        {
            if let load: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(kUserID)
            {
                Static.instance = UserSettings(data: load as! [String: AnyObject])
            }
            else
            {
                Static.instance = UserSettings()
            }
        }
        
        return Static.instance!
    }
    
    init(data: [String: AnyObject])
    {
        super.init()
        
        id = data[kUserID] as! Int
        name = data[kUserName] as! String
        email = data[kUserEmail] as! String
        cards = data[kUserCards] as! [String]
    }
    
    override init()
    {
        super.init()
        
        id = 1
        name = "Test Guy"
        email = "test.guy@lockr.com"
        cards = ["Debit", "Credit"]
        
        
    }
    
    static func checkAuth(completion: (needsAuth: Bool) -> Void) {
        
        // TODO: check tokens/credentials in NSUserSettings, and validate with server asynchronously
        
        completion(needsAuth: false)
        
        
    }
    
}

