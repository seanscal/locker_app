//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNavBar()
        setupMap()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func performMenuSegue() {
        performSegueWithIdentifier("menuSegue", sender: nil)
    }
    
    func performHistorySegue() {
        performSegueWithIdentifier("historySegue", sender: nil)
    }
    
    func styleNavBar() {
        
        // add title view to nav bar
        self.navigationItem.titleView = UIImageView(image: (UIImage(named: "navBarTitle"))?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView?.frame = CGRectMake(ScreenUtils.screenWidth/2 - 25, 2, 50, 30)
        self.navigationItem.titleView?.contentMode = UIViewContentMode.ScaleAspectFit
        
    }
    
    func setupMap() {
        
        // setup sample map
        let mapView = MapManager.BOSTON_MAP
        mapView.delegate = self
        //self.view = mapView
        
        // add boston marker
        let marker = MapManager.BOSTON_MARKER_CUSTOM
        marker.map = mapView
        
        // setup buttons
        let buttonWidth = 80 as CGFloat
        let buttonHeight = 35 as CGFloat
        let buttonPadding = 20 as CGFloat
        
        //TODO: create string constants
        
        // create menu button overlay (bottom right)
        let menuButton = ScreenUtils.primaryButtonWithTitle("Menu")
        menuButton.frame = CGRectMake(ScreenUtils.screenWidth - buttonWidth - buttonPadding, self.view.frame.size.height - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        menuButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(menuButton)
        
        // create history button overlay (bottom left)
        let historyButton = ScreenUtils.primaryButtonWithTitle("History")
        historyButton.frame = CGRectMake(buttonPadding, self.view.frame.size.height - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        historyButton.addTarget(self, action: "performHistorySegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(historyButton)
        
        // add insets to preserve Google logo
        let mapInsets = UIEdgeInsets(top: 0, left: ScreenUtils.screenWidth/2 - 35, bottom: 20, right: 0) as UIEdgeInsets
        mapView.padding = mapInsets
        
        self.view = mapView


    }

}

