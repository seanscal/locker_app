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
let kPrimaryBorderWidth     = 1 as CGFloat
let kPrimaryTintColor       = UIColor.whiteColor()
let kPrimaryBorderColor     = UIColor.whiteColor().CGColor
let kPrimaryFont            = UIFont.boldSystemFontOfSize(16)
let kPrimaryBackgroundColor = UIColor.greenColor()

class ScreenUtils {
    
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
    
}