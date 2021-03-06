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
    var locationButton: UIButton! = nil
    var locationLabel: UILabel! = nil
    var nearestHubButton: UIButton! = nil
    var nearestHubLabel: UILabel! = nil
    var trackingLocation = true
    var displayError = true
    
    var markers: Array<GMSMarker> = []
    
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
        
        // create menu button overlay (bottom right)
        let menuButton = ScreenUtils.primaryButtonWithTitle("Menu")
        menuButton.frame = CGRectMake(ScreenUtils.screenWidth - buttonWidth - buttonPadding, ScreenUtils.screenHeightMinusTopBars - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        menuButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(menuButton)
        
        // create history button overlay (bottom left)
        let historyButton = ScreenUtils.primaryButtonWithTitle("Rentals")
        historyButton.frame = CGRectMake(buttonPadding, ScreenUtils.screenHeightMinusTopBars - buttonHeight - buttonPadding, buttonWidth, buttonHeight)
        historyButton.addTarget(self, action: "performHistorySegue", forControlEvents: UIControlEvents.TouchUpInside)
        mapView.addSubview(historyButton)
      
        // create track location button overlay (top)
        locationButton = UIButton(type: .Custom)
        locationButton.setImage(UIImage(named: "location")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        locationButton.tintColor = UIColor.whiteColor()
        locationButton.frame = CGRectMake((ScreenUtils.screenWidth-173)/2, 20, 36, 36)
        locationButton.layer.cornerRadius = 18
        locationButton.layer.borderWidth = kPrimaryBorderWidth
        locationButton.layer.borderColor = kPrimaryBorderColor
        locationButton.backgroundColor = kLocationActiveColor
        locationButton.addTarget(self, action: "locationPressed", forControlEvents: .TouchUpInside)
        mapView.addSubview(locationButton)
        
        // create track location label
        locationLabel = UILabel()
        locationLabel.text = "Tracking location"
        locationLabel.textAlignment = .Center
        locationLabel.font = UIFont.boldSystemFontOfSize(14.0)
        locationLabel.textColor = kLocationActiveColor
        locationLabel.sizeToFit()
        locationLabel.frame = CGRectMake(locationButton.frame.origin.x + locationButton.frame.size.width + 10, 24, locationLabel.frame.size.width + 10, locationLabel.frame.size.height + 10)
        locationLabel.backgroundColor = kTransparentWhite
        locationLabel.layer.masksToBounds = true
        locationLabel.layer.cornerRadius = 12.0
        mapView.addSubview(locationLabel)
        
        // create nearest hub button overlay (top)
        nearestHubButton = UIButton(type: .Custom)
        nearestHubButton.setImage(UIImage(named: "locate")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        nearestHubButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        nearestHubButton.tintColor = UIColor.whiteColor()
        nearestHubButton.frame = CGRectMake((ScreenUtils.screenWidth-173)/2, 60, 36, 36)
        nearestHubButton.layer.cornerRadius = 18
        nearestHubButton.layer.borderWidth = kPrimaryBorderWidth
        nearestHubButton.layer.borderColor = kPrimaryBorderColor
        nearestHubButton.backgroundColor = kLocationActiveColor
        nearestHubButton.addTarget(self, action: "nearestHubPressed", forControlEvents: .TouchUpInside)
        mapView.addSubview(nearestHubButton)
        
        // create nearest hub label
        nearestHubLabel = UILabel()
        nearestHubLabel.text = "Find nearest hub"
        nearestHubLabel.textAlignment = .Center
        nearestHubLabel.font = UIFont.boldSystemFontOfSize(14.0)
        nearestHubLabel.textColor = kLocationActiveColor
        nearestHubLabel.sizeToFit()
        nearestHubLabel.frame = CGRectMake(nearestHubButton.frame.origin.x + nearestHubButton.frame.size.width + 10, 64, nearestHubLabel.frame.size.width + 10, nearestHubLabel.frame.size.height + 10)
        nearestHubLabel.backgroundColor = kTransparentWhite
        nearestHubLabel.layer.masksToBounds = true
        nearestHubLabel.layer.cornerRadius = 12.0
        mapView.addSubview(nearestHubLabel)
        
        // add insets to preserve Google logo
        let mapInsets = UIEdgeInsets(top: 0, left: ScreenUtils.screenWidth/2 - 34, bottom: 20, right: ScreenUtils.screenWidth/2 - 34) as UIEdgeInsets
        mapView.padding = mapInsets
        
        self.view = mapView
        
        // follow current location with camera
        NSTimer.scheduledTimerWithTimeInterval(kLocationRefreshInterval, target: self, selector: "updateLocation", userInfo: nil, repeats: true)
        
        setupLoadingView()

    }
    
    func nearestHubPressed() {
        
        if let mapView = self.view as? GMSMapView, let currentLocation = LocationManager.Static.lastLocation {
            
            var nearestMarker: GMSMarker? = nil
            var nearestDistance: Double = 0
            
            for marker in markers {
                
                let markerLocation = CLLocation(latitude: marker.position.latitude, longitude: marker.position.longitude)
                
                if nearestMarker == nil {
                    nearestMarker = marker
                    nearestDistance = currentLocation.distanceFromLocation(markerLocation)
                } else {
                    if currentLocation.distanceFromLocation(markerLocation) < nearestDistance {
                        nearestMarker = marker
                        nearestDistance = currentLocation.distanceFromLocation(markerLocation)
                    }
                }
            }
            
            if let marker = nearestMarker {
                
                if trackingLocation {
                    locationPressed()
                }
                
                mapView.animateToLocation(marker.position)
                
                hideNearestHub()
            }
            
        }

    }
    
    func locationPressed() {
        if trackingLocation {
            trackingLocation = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.locationLabel.text = "Location disabled"
                self.locationButton.backgroundColor = UIColor.grayColor()
                self.locationLabel.textColor = UIColor.grayColor()
                self.locationLabel.sizeToFit()
                self.locationLabel.frame = CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, self.locationLabel.frame.size.width + 10, self.locationLabel.frame.size.height + 10)
            })
            
        } else {
            trackingLocation = true
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.locationLabel.text = "Tracking location"
                self.locationButton.backgroundColor = kLocationActiveColor
                self.locationLabel.textColor = kLocationActiveColor
                self.locationLabel.sizeToFit()
                self.locationLabel.frame = CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, self.locationLabel.frame.size.width + 10, self.locationLabel.frame.size.height + 10)
            })
        }
    }
    
    func updateLocation() {
        if trackingLocation, let mapView = self.view as? GMSMapView, let location = LocationManager.userLocation() {
            mapView.animateToLocation(location.coordinate)
        }
        
        var visibleMarker = false
        
        for marker in markers {
            if markerIsVisible(marker) {
                hideNearestHub()
                visibleMarker = true
                break
            }
        }
        
        if !visibleMarker {
            showNearestHub()
        }
    }
    
    func showNearestHub() {
        
        nearestHubButton.hidden = false
        nearestHubLabel.hidden = false
        
        UIView.animateWithDuration(kDefaultAnimationDuration) { () -> Void in
            self.nearestHubButton.alpha = 1.0
            self.nearestHubLabel.alpha = 1.0
        }
        
    }
    
    func hideNearestHub() {
        
        UIView.animateWithDuration(kDefaultAnimationDuration, animations: { () -> Void in
            self.nearestHubButton.alpha = 0.0
            self.nearestHubLabel.alpha = 0.0
            }) { (completed) -> Void in
                self.nearestHubButton.hidden = true
                self.nearestHubLabel.hidden = true
        }
        
    }
    
    func markerIsVisible(marker: GMSMarker) -> Bool {
        if let mapView = self.view as? GMSMapView {
            return mapView.bounds.contains(mapView.projection.pointForCoordinate(marker.position))
        }
        return false
    }
    
    override func viewWillAppear(animated: Bool) {
        loading = true
        displayError = true
        fetchHubs()
    }
    
    func fetchHubs() {
        WebClient.getAllHubs( { (response) -> Void in
            self.loading = false
            (self.view as! GMSMapView).clear()
            self.markers = []
            for jsonHub in response {
                let hub = LockerHub.fromJSON(jsonHub)!
                if let lat = hub.lat, let long = hub.long, let name = hub.name, let _ = hub.openUnits, let _ = hub.totalUnits {
                    let marker = MapManager.customMarkerWithLatitude(lat, longitude: long, title: name, snippet: hub.availabilityString())
                    marker.userData = hub
                    marker.map = self.view as? GMSMapView
                    self.markers.append(marker)
                }
            }
            }) { (error) -> Void in
                self.loading = false
                if(self.displayError) {
                    self.displayError("Could not fetch locker data from the server. Please try again soon.")
                    self.displayError = false
                }
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

