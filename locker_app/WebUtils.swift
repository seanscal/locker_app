//
//  WebUtils.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/27/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

enum ApiVersions : String {
    case Local = "http://localhost:3000/api/"
    case Remote = "http://nulockerhub.com/api/"
}

/**

This class encapsulates global variables that might be
useful/necessary to modify during development/debugging.
Do NOT commit changes made to this class, otherwise 
debug configuration could slip into a production context.

**/

class WebUtils {
    
    static let webApi = ApiVersions.Remote.rawValue
    
    static let kApiMethodHubs = "hubs"
    
}