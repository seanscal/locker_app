//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kActiveRentalSegueId = "activeRentalSegue"
    let kReceiptSegueId = "receiptSegue"
    
    @IBOutlet weak var tableView: UITableView!
    var activeRentals : Array<Rental> = []
    var pastRentals : Array<Rental> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.hidesBackButton = true
        
        //tableView.allowsSelection = false
        
        let backButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "pop")
        self.navigationItem.rightBarButtonItem = backButton
        
        self.navigationItem.title = "Rentals"
        
        getRentals()
        
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "refresh", userInfo: nil, repeats: true)
    }
    
    func getRentals() {
        
        RentalManager.getRentalsForUser(true,
            completion: { (rentals) -> Void in
                self.activeRentals = rentals
                self.refresh()
            }) { (error) -> Void in
                self.displayError("An error occurred loading active rentals. Try again in a few moments.")
            }
        
        RentalManager.getRentalsForUser(false,
            completion: { (rentals) -> Void in
                self.pastRentals = rentals
                self.pastRentals = self.pastRentals.reverse()
                self.refresh()
            }) { (error) -> Void in
                self.displayError("An error occurred loading past rentals. Try again in a few moments.")
            }
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
        return self.pastRentals.count > 0 ? 2 : 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0:
            return max(activeRentals.count, 1)
        default:
            return pastRentals.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0:
            return "Active"
        default:
            return "Past"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //NOTE: ran into a really strange issue where having dequeueReusableCellWithIdentifier calls nested in if blocks was causing them all to use the same prototype, even when others were specified. Had to refactor into less sleek blocks to remedy this.
        
        if indexPath.section == 0 {
            if activeRentals.count > 0 {
                let rental = activeRentals[indexPath.row]
                let cell = tableView.dequeueReusableCellWithIdentifier("HistoryTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
                
                cell.fareLabel.text = rental.runningTotalString()
                cell.hubNameLabel.text = rental.hubName!
                cell.elapsedTimeLabel.text = rental.elapsedTimeString()
                
                return cell
            } else {
                let blankCell = tableView.dequeueReusableCellWithIdentifier("NoRentals", forIndexPath: indexPath) 
                blankCell.textLabel?.text = "No active rental"
                blankCell.userInteractionEnabled = false
                
                return blankCell
            }

        } else {
            let rental = pastRentals[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("HistoricTableViewCell", forIndexPath: indexPath) as! HistoryTableViewCell
            
            cell.fareLabel.text = rental.runningTotalString()
            cell.hubNameLabel.text = rental.hubName!
            cell.elapsedTimeLabel.text = rental.elapsedTimeString()
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kDefaultCellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            let rental = activeRentals[indexPath.row]
            performSegueWithIdentifier(kActiveRentalSegueId, sender: rental)
        } else {
            let rental = pastRentals[indexPath.row]
            performSegueWithIdentifier(kReceiptSegueId, sender: rental)
        }
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == kActiveRentalSegueId) {
            let hubVc = segue.destinationViewController as! LockerHubViewController
            let rental = sender as! Rental
            
            hubVc.initWithRental(rental)
        } else if (segue.identifier == kReceiptSegueId) {
            let receiptVc = segue.destinationViewController as! ReceiptViewController
            let rental = sender as! Rental
            
            receiptVc.rental = rental
        }
    }
    
}

