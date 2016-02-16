//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit

class SettingsViewController: AbstractTableViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Settings"
        
        // configure abstract table view
        tableView.dataSource = self
        tableView.delegate = self
        tableViewType = .Both
        
        // set header & cell titles for menu
        initTableViewWithTitles(header("Hub"), "Search Radius", "Emergency Contact", header("Logout"), "Logout")
        
        // register any outlier cell types
        registerCellTypeForTitles(.Plain, titles: "Logout")
        
        
    }
    
    func pop() {
        let transition = CATransition()
        transition.duration = kDefaultSegueDuration
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let titleForCell = titleForCellAtIndexPath(indexPath)
        
        switch titleForCell {
        default:
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            let alert = UIAlertController(title: titleForCell, message: "You clicked the " + titleForCell + " button.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
}

