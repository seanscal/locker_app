//
//  Extensions.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/25/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

extension Dictionary {
    func toJSON() -> String {
        
        let jsonData: NSData?
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(self as! AnyObject, options: NSJSONWritingOptions(rawValue: 0))
        } catch _ {
            jsonData = nil
        }
        
        return String(data: jsonData!, encoding: NSASCIIStringEncoding)!
    }
}

