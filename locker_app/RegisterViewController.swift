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
  var email = RegisterManager.EMAIL;
  var password = RegisterManager.PASSWORD;
  var firstName = RegisterManager.FIRSTNAME;
  var lastName = RegisterManager.LASTNAME;
  var registerButton = RegisterManager.REGISTER;
  var pin = RegisterManager.PIN;

  override func viewDidLoad() {
    super.viewDidLoad()

    registerButton.addTarget(self, action: "mapsegue", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.view.addSubview(email);
    self.view.addSubview(password);
    self.view.addSubview(firstName);
    self.view.addSubview(lastName);
    self.view.addSubview(registerButton);
    self.view.addSubview(pin);
  }
  
  func mapsegue(){
    let dict : Dictionary = [ "id" : random(), "firstName" : firstName, "lastName" : lastName, "email" : email]
    WebClient.sendUserData(dict, completion: { (response) -> Void in
      if ((response["pin"]) != nil){
        print(response);
      }
      }) { (error) -> Void in
        //TODO: handle error
    }

    performSegueWithIdentifier("mapSegue", sender: self);
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
   
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}