//
//  AbstractTableViewController.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/1/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit

enum TableViewType {
    case Plain     
    case Disclosure
    case Image
    case Both
}

class AbstractTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var cellSections = 1
    var cellTitles : Array<String> = []
    
    private var cellHeaders: Array<String> = []
    
    var footerView : UIView? = nil
    private var imageDict = Dictionary<String, Array<String>>()  //String represents the image name; array represents titles for which to display the image.
    private var cellStyleDict = Dictionary<TableViewType, Array<String>>()
    
    private var cellHeight : CGFloat = kDefaultCellHeight
    var tableViewType : TableViewType = .Plain
    
    func initTableViewWithTitles(titles: String...) {
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
    
    func initTableViewWithCards(){
        cellHeaders.append("Cards")
        cellTitles.append(header("Cards"))
        for card in UserSettings.currentUser.cards {
            cellTitles.append(card)
        }
        
        cellSections++
        cellHeaders.append("Edit")
        cellTitles.append(header("Edit"))
        cellTitles.append("Add/Remove Card")
        registerCellTypeForTitles(.Plain, titles: "Add/Remove Card")
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if cellHeaders.count > section {
            return cellHeaders[section]
        }
        
        return nil
    }
    
    func registerImageNameForTitles(imageName: String, titles: String...) {
        imageDict[imageName] = titles
    }
    
    // overrides the table-wide cell type for the specified cells
    func registerCellTypeForTitles(cellType: TableViewType, titles: String...) {
        cellStyleDict[cellType] = titles
    }
    
    func tableViewTypeForTitle(cellTitle: String) -> TableViewType {
        for (type, titles) in cellStyleDict {
            if titles.contains(cellTitle) {
                return type
            }
        }
        return tableViewType
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let cellTitle = titleForCellAtIndexPath(indexPath)
        cell.textLabel?.text = cellTitle
        
        let cellType = tableViewTypeForTitle(cellTitle)
        
        switch cellType {
            case .Plain:
                break
            case .Disclosure:
                cell.accessoryType = .DisclosureIndicator
                break
            case .Image:
                cell.imageView?.image = cellImageForTitle(cellTitle)
                break
            case .Both:
                cell.accessoryType = .DisclosureIndicator
                cell.imageView?.image = cellImageForTitle(cellTitle)
                break
        }
        
        return cell
    }
    
    private func cellImageForTitle(title: String) -> UIImage {
        for (imageName, titles) in imageDict {
            if titles.contains(title) {
                return UIImage(named: imageName)!
            }
        }
        
        return UIImage()
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
        guard let footerView = footerView else {
            return 0
        }
        
        return (section == cellSections - 1) ? footerView.frame.size.height : 0
    }
}