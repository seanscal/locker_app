//
//  RegisterManager.swift
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

class RegisterManager{

  static let EMAIL = CommonManager.makeTextField(50, text: "Email Address");
  static let PASSWORD = CommonManager.makeTextField(100, text: "Password");
  static let FIRSTNAME = CommonManager.makeTextField(150, text: "First Name");
  static let LASTNAME = CommonManager.makeTextField(200, text: "Last Name");
  static let REGISTER = CommonManager.createButton("Register", posx: 70, posy: 250);
}