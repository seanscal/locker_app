//
//  UserSettings.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/18/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

let kUserID = "_id"
let kUserPIN = "pin"
let kUserName = "name"
let kUserEmail = "email"
let kUserBirthday = "birthday"
let kUserGender = "gender"
let kUserPicture = "picture"
let kUserProximity = "proximity"
let kUserDurationNotif = "durationNotif"
let kUserUpdateTimeStamp = "updateTimeStamp"

//userId = 1 // TODO: implement this class
//static let userName = "Test Guy"
//static let userCards = ["Debit", "Credit"]
//static let userEmail = "test.guy@lockr.com"

class UserSettings: NSObject {
    var userId: String!
    var pin: Int!
    var name: String!
    var birthday: String!
    var gender: String!
    var email: String!
    var picture: String!
    var cards: [String]!
    var proximity: Int!
    var durationNotif: Int!
    var updateTimeStamp: Int!
    
    struct Static
    {
        static var instance: UserSettings?
    }
    
    class var currentUser: UserSettings
    {
        
        if Static.instance == nil
        {
            // DELETE THIS LINE!!!
            // Using to remove NSUserDefaults before app load to force login screen
             NSUserDefaults.standardUserDefaults().removeObjectForKey(kUserID)
            
            
            
            if let load: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(kUserID)
            {
                Static.instance = UserSettings(data: load as! [String: AnyObject])
                
                syncSettings()
            }
            else
            {
                Static.instance = UserSettings()
            }
        }
        
        return Static.instance!
    }
    
    init(data: [String: AnyObject]) {
        super.init()
        
        if(data[kUserID] != nil) {
            userId = data[kUserID] as! String
        }
        
        if(data[kUserName] != nil) {
            name = data[kUserName] as! String
        }
        
        if(data[kUserEmail] != nil) {
            email = data[kUserEmail] as! String
        }
        
        if(data[kUserPicture] != nil) {
            picture = data[kUserPicture] as! String
        }
        
        if(data[kUserPIN] != nil) {
            pin = data[kUserPIN] as! Int
        }
        
        if(data[kUserBirthday] != nil) {
            birthday = data[kUserBirthday] as! String!
        }
        
        if(data[kUserGender] != nil) {
            gender = data[kUserGender] as! String!
        }
        
        if(data[kUserProximity] != nil) {
            proximity = data[kUserProximity] as! Int!
        }
        
        if(data[kUserDurationNotif] != nil) {
            durationNotif = data[kUserDurationNotif] as! Int!
        }
        
        if(data[kUserUpdateTimeStamp] != nil) {
            updateTimeStamp = data[kUserUpdateTimeStamp] as! Int!
        }
        
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: kUserID)
        
    }
    
    func populateUser(data: [String: AnyObject]) {
        Static.instance = UserSettings(data: data)
        
    }
    
    override init()
    {
        super.init()
    }
    
    static func checkAuth(completion: (needsAuth: Bool) -> Void) {
        // TODO: check tokens/credentials in NSUserSettings, and validate with server asynchronously
        if ((UserSettings.currentUser.userId) != nil) {
          WebClient.getUserByID(UserSettings.currentUser.userId, completion: { (response) -> Void in
            completion(needsAuth: true)
            if (UserSettings.currentUser.name == response["name"] as! String){
              completion(needsAuth: true)
            }
            else
            {
              completion(needsAuth: true)
            }
          }) { (error) -> Void in
              //TODO: handle error
          }
        }
        else{
            completion(needsAuth: true)
        }
      
    }
    
    static func syncSettings() -> Void {
        WebClient.getUserByID(Static.instance!.userId, completion: { (response) -> Void in
            
            let serverTime = response["updateTimeStamp"] as! Int
            if(serverTime < Static.instance!.updateTimeStamp) {
                let userInfo: [String: AnyObject] = [
                    "userId": Static.instance!.userId,
                    "pin": Static.instance!.pin,
                    "name": Static.instance!.name,
                    "birthday": Static.instance!.birthday,
                    "gender": Static.instance!.gender,
                    "email": Static.instance!.email,
                    "picture": Static.instance!.picture,
                    "proximity": Static.instance!.proximity,
                    "durationNotif": Static.instance!.durationNotif,
                    "updateTimeStamp": Static.instance!.updateTimeStamp
                ]
                //update server
                WebClient.updateUser(userInfo, completion: { (response) -> Void in
                    //set current user
                    UserSettings.currentUser.populateUser(response)
                    
                }) { (error) -> Void in
                    //TODO: handle error
                }
            }
            else {
                //just set current user to the user on the server
                UserSettings.currentUser.populateUser(response)
            }
        }) { (error) -> Void in
            //TODO: handle error
        }
        
    }
    
}

