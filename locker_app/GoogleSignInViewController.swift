//
//  SignInViewController.swift
//  locker_app
//
//  Created by Sean on 2/6/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

class GoogleSignInViewController: UIViewController, UITableViewDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
  @IBOutlet weak var signInButton: GIDSignInButton!
  var mapViewController: MapViewController!
  
  let env = NSProcessInfo.processInfo().environment
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
    GIDSignIn.sharedInstance().clientID = "863174537857-o18s4kvm4122dudujc1rbffdes43qu6l.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().signInSilently()
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
  
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
      performSegueWithIdentifier("mapSegue", sender: self)
  }
}