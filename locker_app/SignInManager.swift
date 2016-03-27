//
//  LoginManager.swift
//  locker_app
//
//  Created by Sean on 2/12/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TTTAttributedLabel

class SignInManager{
  
  static func makeFBLoginButton()->FBSDKLoginButton{
    let fbLoginButton : FBSDKLoginButton = FBSDKLoginButton()
    fbLoginButton.frame = CGRectMake(70, 200, 180, 40);
    fbLoginButton.readPermissions = ["public_profile", "email", "user_friends","user_birthday"];
    return fbLoginButton;
  }
  
  static func createRegLabel() -> UILabel {
    let label = UILabel(frame: CGRectMake(70, 440, 120, 21))
    label.textAlignment = NSTextAlignment.Left
    label.text = "Don't Have an Account? "
    label.font=label.font.fontWithSize(10);
    return label;
  }
  
  static func createRegButton() -> UIButton {
    let button   = UIButton(type: UIButtonType.System) as UIButton
    button.frame = CGRectMake(168, 440, 100, 21)
    button.setTitle("Register Now", forState: UIControlState.Normal)
    button.titleLabel!.font=button.titleLabel!.font.fontWithSize(10);
    return button
  }
  
  //Custom FB Function
  static func returnUserData()
  {
    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
      
      if ((error) != nil)
      {
        // Process error
        print("Error: \(error)")
      }
      else
      {
        print("fetched user: \(result)")
        let id : NSString = result.valueForKey("id") as! String
        let gender : NSString = result.valueForKey("gender") as! String
        let birthday : NSString = result.valueForKey("birthday") as! String
        let email : NSString = result.valueForKey("email") as! String
        let name : NSString = result.valueForKey("name") as! String
        let dict : Dictionary = [ "id" : id, "birthday" : birthday, "gender" : gender, "email" : email, "name" : name, "pin": 1234]
        
        //WebClient.sendUserData(dict);
      }
    })
  }
}