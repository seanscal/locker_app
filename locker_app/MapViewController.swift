//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit
import GoogleMaps
import ObjectMapper

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var loadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAuth()
        
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
    
    func checkAuth() {

        UserSettings.checkAuth { (needsAuth) -> Void in
            if(needsAuth) {
                self.performSegueWithIdentifier("authSegue", sender: nil)
            }
        }
    }
    
    func styleNavBar() {
        
        // add title view to nav bar
        self.navigationItem.titleView = UIImageView(image: (UIImage(named: "navBarTitle"))?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        self.navigationItem.titleView?.tintColor = UIColor.whiteColor()
        self.navigationItem.titleView?.frame = CGRectMake(ScreenUtils.screenWidth/2 - 25, 2, 50, 30)
        self.navigationItem.titleView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.navigationController?.navigationBar.barTintColor = kPrimaryBackgroundColor
        
        navigationItem.hidesBackButton = true
        
    }
    
    func setupMap() {
        
        // setup sample map
        let mapView = MapManager.BOSTON_MAP
        mapView.delegate = self
        
        WebClient.getAllHubs( { (response) -> Void in
            for jsonHub in response {
                let hub = LockerHub.fromJSON(jsonHub)!
                let marker = MapManager.customMarkerWithLatitude(hub.lat!, longitude: hub.long!, title: hub.name!, snippet: hub.availabilityString())
                marker.userData = hub
                marker.map = mapView
            }
            }) { (error) -> Void in
                self.displayError("Could not fetch locker data from the server. Please try again soon.")
        }
        
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
        let historyButton = ScreenUtils.primaryButtonWithTitle("Rentals")
        historyButton.frame = CGRectMake(buttonPadding, self.view.frame.size.height - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        historyButton.addTarget(self, action: "performHistorySegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(historyButton)
        
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
//        activityIndicator.frame = CGRectMake(ScreenUtils.screenWidth/2 - 75, ScreenUtils.screenHeight/2 - 75, 150, 150)
//        activityIndicator.transform = CGAffineTransformMakeScale(4.054, 4.054);
//        activityIndicator.hidden = false
//        activityIndicator.startAnimating()
//        activityIndicator.color = UIColor.grayColor()
//        mapView.addSubview(activityIndicator)
//        
//        let loadingLabel = UILabel()
//        loadingLabel.text = "LOADING HUBS"
//        loadingLabel.textAlignment = .Center
//        loadingLabel.textColor = UIColor.grayColor()
//        loadingLabel.alpha = 1.0
//        loadingLabel.font = UIFont.boldSystemFontOfSize(35)
//        loadingLabel.sizeToFit()
//        loadingLabel.frame = CGRectMake(0, ScreenUtils.screenHeight/2 + 80, ScreenUtils.screenWidth, loadingLabel.frame.size.height)
//        mapView.addSubview(loadingLabel)
        

        
        // add insets to preserve Google logo
        let mapInsets = UIEdgeInsets(top: 0, left: ScreenUtils.screenWidth/2 - 34, bottom: 20, right: ScreenUtils.screenWidth/2 - 34) as UIEdgeInsets
        mapView.padding = mapInsets
        
        self.view = mapView


    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        performSegueWithIdentifier("lockerHubSegue", sender: marker)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "lockerHubSegue") {
            let hubVc = segue.destinationViewController as! LockerHubViewController
            let marker = sender as! GMSMarker
            
            hubVc.initWithMarker(marker)

            navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .Plain, target: nil, action: nil)
        }
    }

}

