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
  
  @IBOutlet weak var SubmitPinButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    enterPIN.delegate = PINcheck.delegate
    PINcheck.delegate = self
    PINcheck.keyboardType = UIKeyboardType.NumberPad
    print(self.user);
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "mapSegue" {
      mapViewController = segue.destinationViewController as! MapViewController
    }
  }
  
  @IBAction func submitPin(sender: UIButton) {
    
    if (enterPIN.text == PINcheck.text && enterPIN.text!.characters.count == 4)
    {
      self.user!["pin"] = PINcheck.text;
      
      WebClient.updatePIN(self.user!, completion: { (response) -> Void in
        print(response);
        }) { (error) -> Void in
          //TODO: handle error
      }
      self.mapsegue();
    }
    else
    {
      print("shiii")
    }
  }
  
  func PINcheck(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
    replacementString string: String) -> Bool
  {
    let maxLength = 4
    let currentString: NSString = textField.text!
    let newString: NSString =
    currentString.stringByReplacingCharactersInRange(range, withString: string)
    return newString.length <= maxLength
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func mapsegue(){
    
    print(user!["pin"]);

    self.dismissViewControllerAnimated(true) { () -> Void in
    }
  }

}