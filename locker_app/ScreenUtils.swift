//
//  ScreenUtils.swift
//  locker_app
//
//  Created by Eliot Johnson on 1/25/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

// CONSTANTS:

// primary button

let kPrimaryRadius          = 15 as CGFloat
let kPrimaryBorderWidth     = 2 as CGFloat
let kPrimaryTintColor       = UIColor.whiteColor()
let kPrimaryBorderColor     = UIColor.whiteColor().CGColor
let kPrimaryFont            = UIFont.boldSystemFontOfSize(16)
let kPrimaryBackgroundColor = UIColor(red: 0, green: 215, blue: 0)

class ScreenUtils {
    
    static let screenSize: CGRect = UIScreen.mainScreen().bounds
    static let screenHeight = screenSize.height
    static let screenWidth = screenSize.width
    
    static func primaryButtonWithTitle(title: String) -> UIButton {
        let button = UIButton(type: UIButtonType.RoundedRect) as UIButton
        button.layer.cornerRadius = kPrimaryRadius
        button.layer.borderWidth = kPrimaryBorderWidth
        button.layer.borderColor = kPrimaryBorderColor
        button.titleLabel!.font =  kPrimaryFont
        button.tintColor = kPrimaryTintColor
        button.backgroundColor = kPrimaryBackgroundColor
        button.setTitle(title, forState: UIControlState.Normal)
        return button
    }
    
    static func button(title: String, background: UIColor, tint: UIColor) -> UIButton {
        let button = primaryButtonWithTitle(title)
        button.backgroundColor = background
        button.tintColor = tint
        return button
    }
    
    static func rootViewController() -> UIViewController {
        return UIApplication.sharedApplication().keyWindow!.rootViewController!
    }

    
}