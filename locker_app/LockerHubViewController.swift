//
//  LockerHubViewController.swift
//  locker_app
//
//  Created by Eliot Johnson on 2/3/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import MapKit

class LockerHubViewController : UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var inUseCountLabel: UILabel!
    @IBOutlet weak var openUnitsCountLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var detailsBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    var hubName: String?
    var hubId: Int?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    func initWithMarker(marker: GMSMarker) {
        self.hubName = marker.title
        self.hubId = marker.userData as! Int?
        self.latitude = marker.position.latitude
        self.longitude = marker.position.longitude
        
        navigationItem.title = hubName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        formatMapViewHeight()
        
        let mapInsets = UIEdgeInsets(top: ScreenUtils.screenWidth/2 + detailsBarHeightConstraint.constant, left: 0, bottom: 0, right: 0) as UIEdgeInsets
        mapView.padding = mapInsets
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude!, longitude: longitude!, zoom: kMapStandardZoom)
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.setAllGesturesEnabled(false) // disable scrolling, zooming, rotating, etc...
        
        getHubInfo()
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getHubInfo", userInfo: nil, repeats: true)
        
    }
    
    func formatMapViewHeight() {
        let availableScreenHeight = ScreenUtils.screenHeight - navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.height - buttonHeightConstraint.constant
        let mapViewHeight = ScreenUtils.screenWidth/2 + detailsBarHeightConstraint.constant + 200
        let finalHeight = max(availableScreenHeight, mapViewHeight)
        mapHeightConstraint.constant = finalHeight
    }
    
    func mapViewDidStartTileRendering(mapView: GMSMapView!) {
        // only display marker once tiles have rendered
        let hubMarker = MapManager.customMarkerWithLatitude(latitude!, longitude: longitude!, title: hubName!, snippet: "Tap for directions")
        hubMarker.map = mapView
    }
    
    func getHubInfo() {
        WebClient.getHubInfo(hubId!) { (response) -> Void in
            self.updateAvailabilityLabels(response)
        }
    }

    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        giveDirections()
    }
    
    
    func giveDirections() {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            // open with google maps
            UIApplication.sharedApplication().openURL(NSURL(string: gmsUrl())!)

        } else {
            // otherwise, default to apple
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!), addressDictionary: nil))
            destination.name = hubName
            MKMapItem.openMapsWithItems([destination], launchOptions: nil)
        }
    }
    
    private func gmsUrl() -> String {
        let kGMSUrlSchema = "comgooglemaps://?"
        let kHubLocationString = String(latitude) + "," + String(longitude)
        let kDestinationParam = "daddr=" + kHubLocationString
        
        return kGMSUrlSchema + kDestinationParam
    }
    
    private func updateAvailabilityLabels(response: Dictionary<String, AnyObject>) {
        
        let openUnits = response["openUnits"] as! Int
        let totalUnits = response["totalUnits"]as! Int
        let inUse = totalUnits - openUnits
        
        let animation = CATransition()
        animation.duration = 1.0
        animation.type = kCATransitionFade
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        inUseCountLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
        openUnitsCountLabel.layer.addAnimation(animation, forKey: "changeTextTransition")
        
        inUseCountLabel.text = String(inUse)
        openUnitsCountLabel.text = String(openUnits)

    }
    
    @IBAction func reservePressed(sender: AnyObject) {
        performSegueWithIdentifier("reserveSegue", sender: nil)
    }
}
