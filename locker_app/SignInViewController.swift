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
  
  func pinsegue(){
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
        self.pinsegue();
      }
      }) { (error) -> Void in
        //TODO: handle error
    }

    
    self.mapsegue();
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
          let id : NSString = result.valueForKey("id") as! String
          let gender : NSString = result.valueForKey("gender") as! String
          let birthday : NSString = result.valueForKey("birthday") as! String
          let email : NSString = result.valueForKey("email") as! String
          let name : NSString = result.valueForKey("name") as! String
          let dict : Dictionary = [ "id" : id, "birthday" : birthday, "gender" : gender, "email" : email, "name" : name, "pin": "1234"]
          
          WebClient.sendUserData(dict, completion: { (response) -> Void in
            
            print(response);
            if ((response["pin"]) != nil){
              self.mapsegue();
            }
            else{
              self.pinsegue();
            }
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