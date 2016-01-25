//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: figure this out
//        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navBarTitle"))
//        self.navigationItem.titleView?.sizeToFit()
        
        self.navigationItem.title = "Map"
        
        let camera = GMSCameraPosition.cameraWithLatitude(-33.86,
            longitude: 151.20, zoom: 6)
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        let buttonWidth = 80 as CGFloat
        let buttonHeight = 35 as CGFloat
        let buttonPadding = 20 as CGFloat
        
        //TODO: create button factory, string constants, and screen size utility class
        
        // create menu button overlay (bottom right)
        //let menuButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        
        let menuButton = ScreenUtils.primaryButtonWithTitle("Menu")
        menuButton.frame = CGRectMake(self.view.frame.size.width - buttonWidth - buttonPadding, self.view.frame.size.height - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        menuButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(menuButton)
        
        // create history button overlay (bottom left)
        let historyButton = ScreenUtils.primaryButtonWithTitle("History")
        historyButton.frame = CGRectMake(buttonPadding, self.view.frame.size.height - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        historyButton.addTarget(self, action: "performHistorySegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(historyButton)
        
        // add insets to preserve Google logo
        let mapInsets = UIEdgeInsets(top: 0, left: screenSize.width/2 - 35, bottom: 20, right: 0) as UIEdgeInsets
        mapView.padding = mapInsets
        
        self.view = mapView
        
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

}

