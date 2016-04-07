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
        super.viewWillAppear(animated)
        submitButton.layer.cornerRadius = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShown:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHidden:", name: UIKeyboardDidHideNotification, object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardShown(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.height, 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    func keyboardHidden(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
  func register() {
    let name:String = firstNameField.text!+" "+lastNameField.text!
    let dict : Dictionary<String, AnyObject> = [ "name" : name, "email" : emailField.text!, "updateTimeStamp" : Int(NSDate().timeIntervalSince1970) ]
    
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