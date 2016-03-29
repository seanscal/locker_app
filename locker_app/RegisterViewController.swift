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
    let dict : Dictionary = [ "id" : NSUUID().UUIDString, "name" : name, "email" : emailField.text!, "updateTimeStamp" : NSDate.init()]
    WebClient.sendUserData(dict, completion: { (response) -> Void in
      if ((response["pin"]) != nil){
        print(response);
      }
      }) { (error) -> Void in
        //TODO: handle error
    }
    
    UserSettings(data: dict)
    print(UserSettings.currentUser.name)

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