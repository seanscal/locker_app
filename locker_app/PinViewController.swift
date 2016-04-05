//
//  PinViewController.swift
//  locker_app
//
//  Created by Sean on 3/20/16.
//

import Foundation

class PinViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
  
    @IBOutlet var scrollView: UIScrollView!
  var mapViewController: MapViewController!
  
  var user: [String: AnyObject!]?

  @IBOutlet weak var enterPIN: UITextField!
  @IBOutlet weak var PINcheck: UITextField!
  @IBOutlet weak var SubmitPinButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterPIN.delegate = PINcheck.delegate
        PINcheck.delegate = self
        PINcheck.keyboardType = UIKeyboardType.NumberPad
        
        print(self.user!["birthday"]);
        if (self.user!["birthday"] != nil){
            //      DOBfield.hidden = true;
            //      DOBlabel.hidden = true;
        }
        
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
    
    override func viewWillAppear(animated: Bool) {
        SubmitPinButton.layer.cornerRadius = 3
    }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
  
  @IBAction func submitPin(sender: UIButton) {
    errors()
//    if (self.user!["birthday"] == nil){
//      errors();
//      if (DOBfield.text == ""){
//        DOBerror.hidden = false;
//      }
//      else{
//        DOBerror.hidden = true;
//      }
//      if (errorText.hidden == true && DOBerror.hidden == true){
//        DOBerror.hidden = true;
//        self.user!["pin"] = PINcheck.text;
//        self.user!["birthday"] = DOBfield.text;
//        putInfo();
//      }
//    }
//    else{
//      errors();
//      if (errorText.hidden == true){
//        self.user!["pin"] = PINcheck.text;
//        putInfo();
//      }
//    }
    

    //dismissModalStack()
  }
  
  func PINcheck(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool
  {
    let maxLength = 4
    let currentString: NSString = textField.text!
    let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
    return newString.length <= maxLength
  }
  
  func errors() {
    
    if (enterPIN.text != PINcheck.text)
    {
      displayError("Please enter matching PINs")
    }
    else if (enterPIN.text!.characters.count != 4)
    {
      displayError("Please enter 4-digit PINs")
    }
    else{
      self.user!["pin"] = nil;
      putInfo();
    }
  }
  
  func putInfo(){
    WebClient.updatePIN(self.user!, completion: { (response) -> Void in
        self.dismissModalStack()
      }) { (error) -> Void in
        //TODO: handle error
    }
  }
    
  func dismissModalStack() {
    var signInVc = presentingViewController
    signInVc?.dismissViewControllerAnimated(false) { () -> Void in
        signInVc?.dismissViewControllerAnimated(false, completion: { () -> Void in
            //whatever
        })
    }
    
  }

}