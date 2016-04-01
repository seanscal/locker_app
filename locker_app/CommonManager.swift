//
//  CommonManager.swift
//  locker_app
//
//  Created by Sean on 2/14/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//


import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TTTAttributedLabel

class CommonManager{
  
  static func makeTextField(placement: CGFloat, text: String)->UITextField{
    let textField = UITextField(frame: CGRectMake(70, placement, 180, 40))
    textField.placeholder = text
    textField.font = UIFont.systemFontOfSize(15)
    textField.borderStyle = UITextBorderStyle.RoundedRect
    textField.autocorrectionType = UITextAutocorrectionType.No
    textField.keyboardType = UIKeyboardType.Default
    textField.returnKeyType = UIReturnKeyType.Done
    textField.clearButtonMode = UITextFieldViewMode.WhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
    return textField;
  }
  
  static func createButton(text: String, posx: CGFloat, posy: CGFloat) -> UIButton {
    let button   = UIButton(type: UIButtonType.System) as UIButton
    button.frame = CGRectMake(posx, posy, 100, 21)
    button.setTitle(text, forState: UIControlState.Normal)
    return button
  }
}