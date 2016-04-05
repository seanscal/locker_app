//
//  RegisterViewController.swift
//  locker_app
//
//  Created by Sean on 2/14/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class RegisterViewController: UIViewController, UITextFieldDelegate {
  
    @IBOutlet var pinField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var emailField: UITextField!
    

    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    override func viewWillAppear(animated: Bool) {
        submitButton.layer.cornerRadius = 3
    }
    
    
  func register() {
    let name:String = firstNameField.text!+" "+lastNameField.text!
    let picture : String = "http://orig13.deviantart.net/10e3/f/2013/114/8/4/facebook_default_profile_picture___clone_trooper_by_captaintom-d62v2dr.jpg"
    
    let dict : Dictionary<String, AnyObject> = [ "name" : name, "email" : emailField.text!, "picture" : picture, "updateTimeStamp" : Int(NSDate().timeIntervalSince1970) ]
    
    WebClient.sendUserData(dict, completion: { (response) -> Void in
        if ((response["pin"]) != nil){
            UserSettings(data: dict)
            print(response);
            self.dismissModalStack()
        } else {
            // TODO: handle this case?
        }
      }) { (error) -> Void in
        self.displayError(error.description)
    }
  }
    
    func dismissModalStack() {
        let signInVc = presentingViewController
        signInVc?.dismissViewControllerAnimated(false) { () -> Void in
            signInVc?.dismissViewControllerAnimated(false, completion: { () -> Void in
                //whatever
            })
        }
        
    }
    
    func validate() -> Bool {
        // TODO: validate all fields; return true if validation passes
        return true
    }
    
    @IBAction func submitPressed(sender: AnyObject) {
        if validate() {
            register()
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            //nada
        }
    }
   
}