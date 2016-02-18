//
//  SignInViewController.swift
//  locker_app
//
//  Created by Sean on 2/6/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TTTAttributedLabel

class SignInViewController: UIViewController, UITableViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate {
  
  var mapViewController: MapViewController!
  var registerViewController: RegisterViewController!
  
  var fbLoginButton = SignInManager.FBBUTTON;
  var emailField = SignInManager.EMAILFIELD;
  var passwordField = SignInManager.PASSWORDFIELD;
  var registerButton = SignInManager.REGISTERBUTTON;
  var registerLabel = SignInManager.REGISTERLABEL;
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //fb
    fbLoginButton.delegate = self
    self.view.addSubview(fbLoginButton)
    
    //google
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().clientID = "863174537857-o18s4kvm4122dudujc1rbffdes43qu6l.apps.googleusercontent.com"
    //GIDSignIn.sharedInstance().signInSilently()
    
    //Lockr
    emailField.delegate = self;
    self.view.addSubview(emailField);
    passwordField.delegate = self;
    self.view.addSubview(passwordField);
    
    
    registerButton.addTarget(self, action: "regsegue", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(registerButton);
    self.view.addSubview(registerLabel);
  }
  
  func regsegue(){
    performSegueWithIdentifier("registerSegue", sender: self);
  }
  
  func mapsegue(){
    //performSegueWithIdentifier("mapSegue", sender: self);
    self.dismissViewControllerAnimated(true) { () -> Void in
        //
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
    if segue.identifier == "registerSegue" {
      registerViewController = segue.destinationViewController as! RegisterViewController
    }
  }
  
  //required Google Function
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    self.mapsegue();
  }
  
  //Required FB functions
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    if ((error) != nil)
    {
    }
    else {
      SignInManager.returnUserData()
      self.mapsegue();
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
}