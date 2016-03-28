//
//  PinViewController.swift
//  locker_app
//
//  Created by Sean on 3/20/16.
//

import Foundation

class PinViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate {
  
  var mapViewController: MapViewController!
  
  var user: [String: String!]?;

  @IBOutlet weak var enterPIN: UITextField!
  @IBOutlet weak var PINcheck: UITextField!
  @IBOutlet weak var DOBfield: UITextField!
  @IBOutlet weak var DOBlabel: UILabel!
  @IBOutlet weak var SubmitPinButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    enterPIN.delegate = PINcheck.delegate
    PINcheck.delegate = self
    PINcheck.keyboardType = UIKeyboardType.NumberPad

    //print(self.user!["birthday"]);
//    if (self.user!["birthday"] != nil){
//      DOBfield.hidden = true;
//      DOBlabel.hidden = true;
//    }
    
  }
    
    override func viewWillAppear(animated: Bool) {
        SubmitPinButton.layer.cornerRadius = 20
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
    

    dismissModalStack()
  }
  
  func PINcheck(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool
  {
    let maxLength = 4
    let currentString: NSString = textField.text!
    let newString: NSString = currentString.stringByReplacingCharactersInRange(range, withString: string)
    return newString.length <= maxLength
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func mapsegue(){
    self.dismissViewControllerAnimated(true) { () -> Void in
    }
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
  }
  
  func putInfo(){
    WebClient.updatePIN(self.user!, completion: { (response) -> Void in
      }) { (error) -> Void in
        //TODO: handle error
    }
    mapsegue();
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