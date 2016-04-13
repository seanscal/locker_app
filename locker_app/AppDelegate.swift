//
//  AppDelegate.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit
import GoogleMaps
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  
  var window: UIWindow?
    
  var locationManager : LocationManager?
  var notificationManager : NotificationManager?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    //RentalManager.pull()
    
    // initilaize location services
    locationManager = LocationManager()
    notificationManager = NotificationManager()
    
    // provide google maps api key
    GMSServices.provideAPIKey(kGMSApiKey)
    
    // Initialize sign-in
    var configureError: NSError?
    GGLContext.sharedInstance().configureWithError(&configureError)
    assert(configureError == nil, "Error configuring Google services: \(configureError)")
    
    GIDSignIn.sharedInstance().delegate = self
    
    return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  func application(application: UIApplication,
    openURL url: NSURL, options: [String: AnyObject]) -> Bool {
      return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String, annotation: nil)  ||
        GIDSignIn.sharedInstance().handleURL(url,
          sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String,
          annotation: options[UIApplicationOpenURLOptionsAnnotationKey] as? String)
  }
  
  
  func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
    withError error: NSError!) {
      if (error == nil) {
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let name = user.profile.name
        let email = user.profile.email
        // ...
      } else {
        print("\(error.localizedDescription)")
      }
  }
  
  
  func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
    withError error: NSError!) {
      // Perform any operations when the user disconnects from app here.
      // ...
  }
  
  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    FBSDKAppEvents.activateApp()
  }
  
  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        // ensure they approve
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        // if received while Lockr is active, use an alert
        ScreenUtils.visibleViewController().displayMessage(notification.alertTitle!, message: notification.alertBody!)
        
    }
  
  
}

