//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "pop")
        self.navigationItem.rightBarButtonItem = backButton
        
        self.navigationItem.title = "History"
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2    // active and past
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return 1
        default:
            return 3
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return "Section \(section)"
        
        switch(section) {
        case 0:
            return "Active"
        default:
            return "Past"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.accessoryType = .DisclosureIndicator
        
        switch(indexPath.section) {
        case 0:
            cell.textLabel?.text = "NEU Hub - 1 hr, 15 min"
            cell.detailTextLabel?.text = "$4.99"
        default:
            switch(indexPath.row) {
            case 0:
                cell.textLabel?.text = "NYC Hub - 0 hr, 45 min"
                cell.detailTextLabel?.text = "$2.01"
            case 1:
                cell.textLabel?.text = "NEU Hub - 0 hr, 32 min"
                cell.detailTextLabel?.text = "$2.23"
            default:
                cell.textLabel?.text = "Prudential Hub - 2 hr, 36 min"
                cell.detailTextLabel?.text = "$10.54"
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kDefaultCellHeight
    }
    
    
    
}

