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
    
    private var hubName: String?
    private var hubId: Int?
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    
    init(marker: GMSMarker) {
        super.init(nibName: "LockerHubViewController", bundle: nil)
        
        self.hubName = marker.title
        self.hubId = marker.userData as! Int?
        self.latitude = marker.position.latitude
        self.longitude = marker.position.longitude
        
        navigationItem.title = hubName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        let camera = GMSCameraPosition.cameraWithLatitude(latitude!, longitude: longitude!, zoom: kMapStandardZoom)
        
        let hubMarker = MapManager.customMarkerWithLatitude(latitude!, longitude: longitude!, title: hubName!, snippet: "Tap for directions")
        hubMarker.map = mapView
        mapView.camera = camera
        mapView.delegate = self
        
        getHubInfo()
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getHubInfo", userInfo: nil, repeats: true)
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
