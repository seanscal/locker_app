//
//  AbstractTableViewController.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/1/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

//enum TableViewType {
//    case Plain
//    case Styled
//}

class AbstractTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cellSections = 1
    private var cellTitles : Array<String> = []
    private var cellHeaders: Array<String> = []
    
    var footerView : UIView? = nil
    
    private var cellHeight : CGFloat = kDefaultCellHeight
//    var tableViewType : TableViewType = .Plain {
//        didSet {
//            if(tableViewType == .Styled) {
//                
//            }
//        }
//    }
    
    func initWithTitles(titles: String...) {
        for title in titles {
            if(isHeader(title)) {
                if(titles.indexOf(title) != 0) {
                    cellSections++
                }
                cellHeaders.append(fromHeader(title))
                cellTitles.append(title)
            }
            else {
                cellTitles.append(title)
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if cellHeaders.count > section {
            return cellHeaders[section]
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = titleForCellAtIndexPath(indexPath)
        return cell
    }
    
    func titleForCellAtIndexPath(indexPath: NSIndexPath) -> String {
        var section = 0
        var row = 0
        
        for title in cellTitles {
            if isHeader(title) {
                if cellTitles.indexOf(title) == 0 {
                    continue
                }
                section++
            }
            else if section == indexPath.section {
                if row == indexPath.row {
                    return title
                }
                else {
                    row++
                }
            }
        }
        
        return String()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cellSections
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var loopSection = 0
        var rows = 0
        for title in self.cellTitles {
            if isHeader(title) {
                if self.cellTitles.indexOf(title) != 0 {
                    if loopSection == section {
                        return rows
                    } else {
                        rows = 0
                        loopSection++
                    }
                }
            }
            else {
                rows++
            }

        }
        return rows
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func header(text: String) -> String {
        return kHeaderPrefix + text
    }
    
    func isHeader(text: String) -> Bool {
        return text.containsString(kHeaderPrefix)
    }
    
    func fromHeader(text: String) -> String {
        return text.substringFromIndex(text.startIndex.advancedBy(kHeaderPrefix.characters.count))
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == cellSections - 1 {
            return footerView
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if(section == cellSections - 1) {
            return (footerView?.frame.size.height)!
        }
        
        return 0
    }
}