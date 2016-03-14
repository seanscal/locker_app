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
    var activeRentals : Array<Rental> = []
    var pastRentals : Array<Rental> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "pop")
        self.navigationItem.rightBarButtonItem = backButton
        
        self.navigationItem.title = "Rentals"
        
        tableView.registerNib(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        
        WebClient.getRentalsForUser(true) { (response) -> Void in
            for jsonRental in response {
                let rental = Rental.fromJSON(jsonRental)!
                self.activeRentals.append(rental)
            }
            self.tableView.reloadData()
        }
        
        WebClient.getRentalsForUser(false) { (response) -> Void in
            for jsonRental in response {
                let rental = Rental.fromJSON(jsonRental)!
                self.pastRentals.append(rental)
            }
            self.tableView.reloadData()
        }
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "refresh", userInfo: nil, repeats: true)
    }

    func pop() {
        let transition = CATransition()
        transition.duration = kDefaultSegueDuration
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let active = self.activeRentals.count > 0 ? 1 : 0
        let past = self.pastRentals.count > 0 ? 1 : 0
        return active + past
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return activeRentals.count
        default:
            return pastRentals.count
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
        let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
        
        if indexPath.section == 0 {
            let rental = activeRentals[indexPath.row]
            
            cell.fareLabel.text = rental.runningTotalString()
            cell.hubNameLabel.text = rental.hubName!
            cell.elapsedTimeLabel.text = rental.elapsedTimeString()
        } else {
            let rental = pastRentals[indexPath.row]
            
            cell.fareLabel.text = rental.runningTotalString()
            cell.hubNameLabel.text = rental.hubName!
            cell.elapsedTimeLabel.text = rental.elapsedTimeString()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kDefaultCellHeight
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
}

