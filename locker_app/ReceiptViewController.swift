//
//  ReceiptViewController.swift
//  locker_app
//
//  Created by Eliot Johnson on 4/6/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation

class ReceiptViewController: UIViewController {
    
    @IBOutlet var hubName: UILabel!
    @IBOutlet var lockerNumber: UILabel!
    @IBOutlet var baseRate: UILabel!
    @IBOutlet var hourlyRate: UILabel!
    @IBOutlet var timeIn: UILabel!
    @IBOutlet var timeOut: UILabel!
    @IBOutlet var elapsedTime: UILabel!
    @IBOutlet var totalCost: UILabel!
    
    var rental: Rental! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Receipt"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        hubName.text = rental.hubName
        lockerNumber.text = String(rental.lockerId!)
        baseRate.text = String(format: "$%.2f", rental.baseRate!)
        hourlyRate.text = String(format: "$%.2f", rental.hourlyRate!)
        timeIn.text = formatter.stringFromDate(rental.checkInTime!)
        timeOut.text = formatter.stringFromDate(rental.checkOutTime!)
        elapsedTime.text = rental.elapsedTimeString()
        totalCost.text = rental.runningTotalString()
        
    }
    
}