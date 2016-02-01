//
//  AbstractTableViewController.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/1/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

class AbstractTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cellTitles : Array<String> = []
    
    func initWithTitles(titles: String...) {
        cellTitles = titles
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = cellTitles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles.count
    }
    
}