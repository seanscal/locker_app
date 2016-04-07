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
  var user: [String: AnyObject!]?;
  
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
//    GIDSignIn.sharedInstance().signInSilently()
    
  }
  
  override func viewWillAppear(animated: Bool) {
      
      // facebook button setup
      facebookButton.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
      facebookButton.delegate = self
      
      // native button setup
      signInButton.layer.cornerRadius = 3.0
      
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
    pushToPin = false
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
      print(self.user)
      pinViewController.user = self.user;
    }
  }
  
  //required Google Function
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {

    if error != nil {
        displayError(error.description)
    }

    else {
        // success
        let idToken = user.authentication.idToken // Safe to send to the server
        let name = user.profile.name
        let email = user.profile.email
        
        self.user = ["name" : name, "email" : email, "updateTimeStamp" : Int(NSDate.init().timeIntervalSince1970)]
        
        WebClient.sendUserData(self.user!, completion: { (response) -> Void in
            WebClient.updateUser(self.user!, completion: { (response) -> Void in
                if ((response["pin"]) != nil){
                    UserSettings.currentUser.populateUser(response)
                    UserSettings.syncSettings()
                    self.mapsegue();
                }
                else{
                    if (self.isViewLoaded() && self.view.window != nil) {
                        self.pinsegue()
                    } else {
                        self.pushToPin = true
                    }
                }
            }) { (error) -> Void in
                //TODO: handle error
            }
        }) { (error) -> Void in
            //TODO: handle error
        }
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
          let email = result.valueForKey("email") as! String
          let name = result.valueForKey("name") as! String
          let picture : NSString = result.valueForKey("picture")!.valueForKey("data")!.valueForKey("url") as! String
            self.user = ["name" : name, "email" : email, "updateTimeStamp" : Int(NSDate.init().timeIntervalSince1970), "picture": picture]
            
            WebClient.sendUserData(self.user!, completion: { (response) -> Void in
                WebClient.updateUser(self.user!, completion: { (response) -> Void in
                    if ((response["pin"]) != nil){
                        UserSettings.currentUser.populateUser(response)
                        UserSettings.syncSettings()
                        self.mapsegue();
                    }
                    else{
                        if (self.isViewLoaded() && self.view.window != nil && self.presentingViewController?.presentingViewController != nil) {
                          
                            print("viewcontroller")
                              print (self.presentingViewController?.presentingViewController);
                              print (self.presentingViewController?.presentedViewController);
                    
                          
                            self.pinsegue()
                        } else {
                            self.pushToPin = true
                        }
                    }
                }) { (error) -> Void in
                    //TODO: handle error
                    self.displayError(error.description)
                }
            }) { (error) -> Void in
                //TODO: handle error
                self.displayError(error.description)
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