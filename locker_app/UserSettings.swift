//
//  UserSettings.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/18/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

let kUserID = "userID"
let kUserPIN = "userPIN"
let kUserName = "userName"
let kUserEmail = "userEmail"
let kUserBirthday = "userBirthday"
let kUserGender = "userGender"
let kUserCards = "userCards"
let kUserPicture = "userPicture"
let kUserProximity = "userProximity"
let kUserDurationNotif = "userDurationNotif"
let kUserUpdateTimeStamp = "userUpdateTimeStamp"

//userId = 1 // TODO: implement this class
//static let userName = "Test Guy"
//static let userCards = ["Debit", "Credit"]
//static let userEmail = "test.guy@lockr.com"

class UserSettings: NSObject {
    var id: String!
    var pin: Int!
    var name: String!
    var birthday: String!
    var gender: String!
    var email: String!
    var picture: String!
    var cards: [String]!
    var proximity: Int!
    var durationNotif: Int!
    var updateTimeStamp: NSDate!
    
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
        
        id = data[kUserID] as! String
        name = data[kUserName] as! String
        email = data[kUserEmail] as! String
        picture = data[kUserPicture] as! String
        cards = data[kUserCards] as! [String]
        pin = data[kUserPIN] as! Int
        birthday = data[kUserBirthday] as! String!
        gender = data[kUserGender] as! String!
        proximity = data[kUserProximity] as! Int!
        durationNotif = data[kUserDurationNotif] as! Int!
        updateTimeStamp = data[kUserUpdateTimeStamp] as! NSDate!
    }
    
    override init()
    {
        super.init()
        
        id = "1"
        name = "Test Guy"
        email = "test.guy@lockr.com"
        cards = ["Debit", "Credit"]
        
    }
    
    static func checkAuth(completion: (needsAuth: Bool) -> Void) {
        
        // TODO: check tokens/credentials in NSUserSettings, and validate with server asynchronously
        
        completion(needsAuth: true)
        
    }
    
}

