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

class SignInViewController: UIViewController, UITableViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate, FBSDKLoginButtonDelegate, UITextFieldDelegate {
  @IBOutlet weak var signInButton: GIDSignInButton!
  var mapViewController: MapViewController!
  
  var loginView : FBSDKLoginButton = FBSDKLoginButton()
  let env = NSProcessInfo.processInfo().environment
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //fb
    loginView.frame = CGRectMake(70, 200, 180, 40)
    self.view.addSubview(loginView)
    loginView.readPermissions = ["public_profile", "email", "user_friends","user_birthday"]
    loginView.delegate = self
    
    //google
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().clientID = "863174537857-o18s4kvm4122dudujc1rbffdes43qu6l.apps.googleusercontent.com"
//    GIDSignIn.sharedInstance().signInSilently()
  }
  
  
  //required Google Function
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
    performSegueWithIdentifier("mapSegue", sender: self)
  }
  
  
  //Required FB functions
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    if ((error) != nil)
    {
    }
    else {
      returnUserData()
      performSegueWithIdentifier("mapSegue", sender: self)
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }

  //Custom FB Function
  func returnUserData()
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
        print("User ID is: \(id)")
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
}