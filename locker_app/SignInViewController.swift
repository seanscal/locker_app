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

class SignInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate {
  
  var mapViewController: MapViewController!
  var registerViewController: RegisterViewController!
  var pinViewController: PinViewController!
  
  @IBOutlet var signInButton: UIButton!
  @IBOutlet var passwordField: UITextField!
  @IBOutlet var emailField: UITextField!
  @IBOutlet var facebookButton: FBSDKLoginButton!
  @IBOutlet var googleButton: GIDSignInButton!
  
  var pushToPin = false
  var user: [String: String!]?;
  
  @IBAction func registerPressed(sender: AnyObject) {
      regsegue()
  }
  @IBAction func signInPressed(sender: AnyObject) {
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //google
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().clientID = "863174537857-o18s4kvm4122dudujc1rbffdes43qu6l.apps.googleusercontent.com"
    //GIDSignIn.sharedInstance().signInSilently()
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    
  }
    
  func dismissKeyboard() {
      view.endEditing(true)
  }
  
  override func viewWillAppear(animated: Bool) {
      
      // facebook button setup
      facebookButton.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
      facebookButton.delegate = self
      
      // native button setup
      signInButton.layer.cornerRadius = 24.0
      
  }
  
  override func viewDidAppear(animated: Bool) {
      if pushToPin {
          pinsegue()
          self.pushToPin = false
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
          let email = result.valueForKey("email") as! String
          let name = result.valueForKey("name") as! String
          let picture : NSString = result.valueForKey("picture")!.valueForKey("data")!.valueForKey("url") as! String
          self.user = [ "id" : id, "gender" : gender, "email" : email, "name" : name]
          let userInfo : Dictionary = [ "id" : id, "name" : name, "email" : email, "updateTimeStamp" : NSDate.init(), "picture": picture]
          
          UserSettings(data: userInfo)
          
          WebClient.sendUserData(self.user!, completion: { (response) -> Void in
            if ((response["pin"]) != nil){
              self.mapsegue();
            }
            else{
              self.pushToPin = true
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