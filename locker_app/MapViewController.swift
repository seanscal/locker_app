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
    
    var tintedView: UIView!
    var activityIndicator: UIActivityIndicatorView!
    var loadingLabel : UILabel!
    
    private var _loading: Bool = true
    var loading: Bool {
        get{
            return _loading && mapRendered
        }
        set {
            _loading = newValue
            updateLoadingView()
        }
    }
    
    var mapRendered: Bool = false
    
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
        
        // add insets to preserve Google logo
        let mapInsets = UIEdgeInsets(top: 0, left: ScreenUtils.screenWidth/2 - 34, bottom: 20, right: ScreenUtils.screenWidth/2 - 34) as UIEdgeInsets
        mapView.padding = mapInsets
        
        self.view = mapView
        
        setupLoadingView()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("fetchHubs"), userInfo: nil, repeats: false)

    }
    
    func fetchHubs() {
        WebClient.getAllHubs( { (response) -> Void in
            self.loading = false
            for jsonHub in response {
                let hub = LockerHub.fromJSON(jsonHub)!
                if let lat = hub.lat, let long = hub.long, let name = hub.name, let _ = hub.openUnits, let _ = hub.totalUnits {
                    let marker = MapManager.customMarkerWithLatitude(lat, longitude: long, title: name, snippet: hub.availabilityString())
                    marker.userData = hub
                    marker.map = self.view as? GMSMapView
                }
            }
            }) { (error) -> Void in
                self.loading = false
                self.displayError("Could not fetch locker data from the server. Please try again soon.")
        }
    }
    
    func mapViewDidFinishTileRendering(mapView: GMSMapView!) {
        // suppress loading overlay until map renders
        mapRendered = true
        updateLoadingView()
    }
    
    func updateLoadingView() {
        if loading {
            activateLoadingView()
        } else {
            dismissLoadingView()
        }
    }
    
    func activateLoadingView() {
        tintedView.hidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidden = false
        loadingLabel.hidden = false
    }
    
    func dismissLoadingView() {
        tintedView.hidden = true
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true
        loadingLabel.hidden = true
    }
    
    func setupLoadingView() {
        // loading indicator
        tintedView = UIView(frame: CGRectMake(0, 0, ScreenUtils.screenWidth, ScreenUtils.screenHeight))
        tintedView.backgroundColor = UIColor.grayColor()
        tintedView.alpha = 0.5
        tintedView.hidden = true
        view.addSubview(tintedView)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.frame = CGRectMake(ScreenUtils.screenWidth/2 - 18, ScreenUtils.screenHeight/2 - 18, activityIndicator.frame.size.height, activityIndicator.frame.size.height)
        activityIndicator.hidden = true
        view.addSubview(activityIndicator)
        
        loadingLabel = UILabel()
        loadingLabel.text = "Fetching locker data..."
        loadingLabel.textAlignment = .Center
        loadingLabel.textColor = UIColor.whiteColor()
        loadingLabel.alpha = 1.0
        loadingLabel.font = UIFont.boldSystemFontOfSize(17)
        loadingLabel.sizeToFit()
        loadingLabel.frame = CGRectMake(0, ScreenUtils.screenHeight/2 + 25, ScreenUtils.screenWidth, loadingLabel.frame.size.height)
        loadingLabel.hidden = true
        view.addSubview(loadingLabel)
        
        updateLoadingView()
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

