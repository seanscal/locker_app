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
  @IBOutlet weak var errorText: UILabel!
  @IBOutlet weak var PINcheck: UITextField!
  
  @IBOutlet weak var SubmitPinButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    enterPIN.delegate = PINcheck.delegate
    PINcheck.delegate = self
    PINcheck.keyboardType = UIKeyboardType.NumberPad
    errorText.hidden = true;
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
  
  @IBAction func submitPin(sender: UIButton) {
    
    print(enterPIN.text);
    print(PINcheck.text);
    
    if (enterPIN.text != PINcheck.text)
    {
      errorText.text = "PINs do not match";
      errorText.hidden = false;
    }
    else if (enterPIN.text!.characters.count != 4)
    {
      errorText.text = "PIN must be 4 digits";
      errorText.hidden = false;
    }
    else{
      self.user!["pin"] = PINcheck.text;
      
      WebClient.updatePIN(self.user!, completion: { (response) -> Void in
        }) { (error) -> Void in
          //TODO: handle error
      }
      performSegueWithIdentifier("mapSegue", sender: self);
    }
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

}