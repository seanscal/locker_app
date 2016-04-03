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
            // NSUserDefaults.standardUserDefaults().removeObjectForKey(kUserID)
            
            
            
            if let load: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(kUserID)
            {
                Static.instance = UserSettings(data: load as! [String: AnyObject])
//                print(Static.instance!.userId)
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
        userId = data[kUserID] as! String
        name = data[kUserName] as! String
        email = data[kUserEmail] as! String
        picture = data[kUserPicture] as! String
        pin = data[kUserPIN] as! Int
        birthday = data[kUserBirthday] as! String!
        gender = data[kUserGender] as! String!
        proximity = data[kUserProximity] as! Int!
        durationNotif = data[kUserDurationNotif] as! Int!
        updateTimeStamp = data[kUserUpdateTimeStamp] as! Int!
        
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
            completion(needsAuth: false)
        }
        else{
            completion(needsAuth: true)
        }
        
    }
    
    static func syncSettings() -> Void {
        WebClient.getUserByID(Static.instance!.userId, completion: { (response) -> Void in
//            print (response)
            
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

