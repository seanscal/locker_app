//
//  RegisterViewController.swift
//  locker_app
//
//  Created by Sean on 2/14/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class RegisterViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
  
  var mapViewController: MapViewController!
  
  var emailField = RegisterManager.EMAIL;
  var passwordField = RegisterManager.PASSWORD;
  var firstNameField = RegisterManager.FIRSTNAME;
  var lastNameField = RegisterManager.LASTNAME;
  var registerButton = RegisterManager.REGISTER;
  var pin = RegisterManager.PIN;

  override func viewDidLoad() {
    super.viewDidLoad()

    registerButton.addTarget(self, action: "mapsegue", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.view.addSubview(emailField);
    self.view.addSubview(passwordField);
    self.view.addSubview(firstNameField);
    self.view.addSubview(lastNameField);
    self.view.addSubview(registerButton);
    self.view.addSubview(pin);
  }
  
  func mapsegue(){
    let name:String = firstNameField.text!+lastNameField.text!
    let picture : String = "http://orig13.deviantart.net/10e3/f/2013/114/8/4/facebook_default_profile_picture___clone_trooper_by_captaintom-d62v2dr.jpg"
    
    
    let dict : Dictionary = [ "userId" : NSUUID().UUIDString, "name" : name, "email" : emailField.text!, "picture" : picture, "updateTimeStamp" : NSDate.init()]
    WebClient.sendUserData(dict, completion: { (response) -> Void in
      if ((response["pin"]) != nil){
        UserSettings(data: dict)
        print(response);
      }
      }) { (error) -> Void in
        //TODO: handle error
    }

    performSegueWithIdentifier("mapSegue", sender: self);
  }
    
  // TODO: add validation for text fields
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            //nada
        }
    }
   

}