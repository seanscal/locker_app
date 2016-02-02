//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit

class MenuViewController: AbstractTableViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "pop")
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Menu"
        
        // configure abstract table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // set header & cell titles for menu
        initWithTitles(header("Account"), "Profile", "Payment", "Settings", header("Help"), "About", "Report an issue", "Logout")
        
        // add "built in boston" footer
        footerView = UIImageView(image: UIImage(named: "builtInBoston"))
        footerView?.contentMode = .ScaleAspectFit
        
    }
    
    func pop() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func performAccountSegue() {
        performSegueWithIdentifier("accountSegue", sender: nil)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let titleForCell = titleForCellAtIndexPath(indexPath)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        let alert = UIAlertController(title: titleForCell, message: "You clicked the " + titleForCell + " button.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        
        switch titleForCell {
            case "Profile":
                break
            case "Payment":
                break
            case "Settings":
                break
            case "About":
                break
            case "Report an issue":
                break
            case "Logout":
                break
            default:
                break
        }
    }
    
}

