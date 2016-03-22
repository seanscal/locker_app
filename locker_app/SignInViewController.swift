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
  var pinViewController: PinViewController!
  
  var fbLoginButton = SignInManager.FBBUTTON;
  var emailField = SignInManager.EMAILFIELD;
  var passwordField = SignInManager.PASSWORDFIELD;
  var registerButton = SignInManager.REGISTERBUTTON;
  var registerLabel = SignInManager.REGISTERLABEL;
  var pushToPin = false
  var user: [String: String!]?;
  
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
    
    override func viewDidAppear(animated: Bool) {
        if pushToPin {
            pinsegue()
        }
    }
  
  func regsegue(){
    performSegueWithIdentifier("registerSegue", sender: self);
  }
  
  func pinsegue() {
    performSegueWithIdentifier("pinSegue", sender: self);
  }
  
  func mapsegue(){
    self.dismissViewControllerAnimated(true) { () -> Void in
        //handle dismiss
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
    if segue.identifier == "registerSegue" {
      registerViewController = segue.destinationViewController as! RegisterViewController
    }
    if segue.identifier == "pinSegue"{
      pinViewController = segue.destinationViewController as! PinViewController;
      pinViewController.user = self.user;
    }
  }
  
  //required Google Function
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    let idToken = user.authentication.idToken // Safe to send to the server
    let name = user.profile.name
    let email = user.profile.email
    
    let dict : Dictionary = [ "id" : idToken, "email" : email, "name" : name]
    
    WebClient.sendUserData(dict, completion: { (response) -> Void in
      if ((response["pin"]) != nil){
        self.mapsegue();
      }
      else{
        self.user = dict;
        self.pinsegue();
      }
      }) { (error) -> Void in
        //TODO: handle error
    }
  }
  
  //Required FB functions
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    if ((error) != nil)
    {
    }
    else {
      let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,interested_in,gender,birthday,email,age_range,name,picture.width(480).height(480)"])
      graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
        
        if ((error) != nil)
        {
          print("Error: \(error)")
        }
        else
        {
          let id = result.valueForKey("id") as! String
          let gender  = result.valueForKey("gender") as! String
          let birthday  = ""
          let email = result.valueForKey("email") as! String
          let name = result.valueForKey("name") as! String
          let dict : Dictionary = [ "id" : id, "birthday" : birthday, "gender" : gender, "email" : email, "name" : name]
          
          WebClient.sendUserData(dict, completion: { (response) -> Void in
//            if ((response["pin"]) != nil){
//              self.mapsegue();
//            }
//            else{
              //self.user = dict;
              self.pushToPin = true
              
//            }
            }) { (error) -> Void in
              //TODO: handle error
          }
        }
      })

      
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
}