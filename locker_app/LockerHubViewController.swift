//
//  LockerHubViewController.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/3/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

class LockerHubViewController : AbstractTableViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var lockerName: String?
    private var lockerId: Int?
    
    init(lockerName: String, lockerId: Int) {
        super.init(nibName: "LockerHubViewController", bundle: nil)
        
        self.lockerName = lockerName
        self.lockerId = lockerId
        
        navigationItem.title = lockerName
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        initTableViewWithTitles(header("Open Units"), "1", "5", header("Reserved Units"), "2", header("In Use"), "3", "4", "6")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
