//
//  UserSettings.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/18/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class UserSettings {
    static let userId = 1 // TODO: implement this class
    
    static func checkAuth(completion: (needsAuth: Bool) -> Void) {
        
        // TODO: check tokens/credentials in NSUserSettings, and validate with server asynchronously
        
        completion(needsAuth: false)
        
    }
}
