//
//  Extensions.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/25/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

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

extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef!
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}


extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UIViewController
{
    func displayError(error: String) {
        
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func displayMessage(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func displayMessage(title: String, message: String, completion: () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let action = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            completion()
        }
        alert.addAction(action)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
}
