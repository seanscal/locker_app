//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit

class ProfileViewController: AbstractTableViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.title = "Profile"
        
        // configure abstract table view
        tableView.dataSource = self
        tableView.delegate = self
        tableViewType = .Both
        
        let frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)
        let headerImageView = UIImageView(frame: frame)
        if let url = NSURL(string: UserSettings.currentUser.picture) {
            if let data = NSData(contentsOfURL: url) {
                headerImageView.image = UIImage(data: data)
            }        
        }
        tableView.tableHeaderView = headerImageView
        
        // set header & cell titles for menu
        initTableViewWithTitles(header("User Info"),UserSettings.currentUser.name, UserSettings.currentUser.email)
        
    
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

