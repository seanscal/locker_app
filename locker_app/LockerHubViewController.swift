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

let kCountdownTime = 10

enum DisplayMode {
    case ActiveRental
    case PreRental
}

class LockerHubViewController : UIViewController, GMSMapViewDelegate {

    @IBOutlet var activeAlertLabel: UILabel!
    @IBOutlet var hourlyRateLabel: UILabel!
    @IBOutlet var baseRateLabel: UILabel!
    @IBOutlet weak var inUseCountLabel: UILabel!
    @IBOutlet weak var openUnitsCountLabel: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var checkInTime: UILabel!
    @IBOutlet weak var runningTotal: UILabel!
    @IBOutlet weak var activeRentalView: UIView!
    @IBOutlet weak var inUseView: UIView!
    @IBOutlet weak var openUnitsView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    
    // open locker view
    @IBOutlet var openLockerView: UIView!
    @IBOutlet var countdownContainer: UIView!
    @IBOutlet var countdownLabel: UILabel!

    @IBOutlet weak var detailsBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    var timer: NSTimer!
    
    var hub: LockerHub?
    
    // override setter for displayMode property to automatically update UI to illustrate an active rental
    private var _displayMode : DisplayMode = .PreRental
    var displayMode: DisplayMode {
        get {
            return self._displayMode
        }
        set {
            self._displayMode = newValue
            updateDisplay()
        }
    }
    
    // override setter for rental property to automatically detect an active rental and update UI accordingly
    private var _rental: Rental? = nil
    var rental: Rental? {
        get {
            return self._rental
        }
        set {
            self._rental = newValue
            if (newValue != nil) {
                self.displayMode = .ActiveRental
            }
            else {
                self.displayMode = .PreRental
            }
        }
    }
    
    func initWithMarker(marker: GMSMarker) {
        self.hub = marker.userData as! LockerHub?
        navigationItem.title = hub!.name
    }
    
    func initWithRental(rental: Rental) {
        self.hub = LockerHub(rental: rental)
        navigationItem.title = hub!.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None

        formatMapViewHeight()
    }
    
    override func viewWillAppear(animated: Bool) {
        let mapInsets = UIEdgeInsets(top: ScreenUtils.screenWidth/2 + detailsBarHeightConstraint.constant + 50, left: 0, bottom: 0, right: 0) as UIEdgeInsets
        mapView.padding = mapInsets
        
        let camera = GMSCameraPosition.cameraWithLatitude(hub!.lat!, longitude: hub!.long!, zoom: kMapStandardZoom)
        mapView.camera = camera
        mapView.delegate = self
        mapView.settings.setAllGesturesEnabled(false) // disable scrolling, zooming, rotating, etc...
        
        displayRates()
        getHubInfo()
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getHubInfo", userInfo: nil, repeats: true)
        checkForActiveRental()
        
        updateDisplay()
        
        countdownContainer.layer.cornerRadius = countdownContainer.frame.size.height / 4
    }
    
    func displayRates() {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        
        baseRateLabel.text = formatter.stringFromNumber(hub!.baseRate!)
        hourlyRateLabel.text = formatter.stringFromNumber(hub!.hourlyRate!)
    }
    
    func initiateOpenLockerView() {
        openLockerView.alpha = 0
        openLockerView.hidden = false
        
        UIView.animateWithDuration(kDefaultAnimationDuration) { () -> Void in
            self.openLockerView.alpha = 1
        }
        
        countdownLabel.text = String(kCountdownTime)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    func dismissOpenLockerView() {
        UIView.animateWithDuration(kDefaultAnimationDuration, animations: { () -> Void in
            self.openLockerView.alpha = 0
            }) { (completed) -> Void in
                self.openLockerView.hidden = true
                self.displayMessage("Time expired", message: "Your unit automatically re-locked after " + String(kCountdownTime) + " seconds.")
        }
        
        timer.invalidate()
        timer = nil
    }
    
    func updateTimer() {
        var currentTime = Int(countdownLabel.text!)!
        if currentTime == 0 {
            dismissOpenLockerView()
        } else {
            currentTime--
            countdownLabel.text = String(currentTime)
        }
    }
    
    func checkForActiveRental() {
        RentalManager.checkForActiveRental(hub!.uid!, completion: { (rental) -> Void in
            self.rental = rental
            self.calculateRate()
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateRate", userInfo: nil, repeats: true)
        }) { (error) -> Void in
            //TODO: handle error
        }
    }
    
    func calculateRate() {
        let elapsedHours = NSDate().timeIntervalSinceDate(rental!.checkInTime!) / kSecondsPerHour
        let runningTotal = hub!.baseRate! + (hub!.hourlyRate! * elapsedHours)
        
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        let timeString: String = formatter.stringFromDate(rental!.checkInTime!)
        
        self.checkInTime.text = timeString
        self.runningTotal.text = String(format:"$%.2f", runningTotal)
    }
    
    func updateRate() {
        let elapsedHours = NSDate().timeIntervalSinceDate(rental!.checkInTime!) / kSecondsPerHour
        let runningTotal = hub!.baseRate! + (hub!.hourlyRate! * elapsedHours)
        self.runningTotal.text = String(format:"$%.2f", runningTotal)
    }
    
    func updateDisplay() {
        let active = displayMode == .ActiveRental
        
        if active {
            activeAlertLabel.text = "LOCKER #" + String(rental!.lockerId!)
        }

        UIView.animateWithDuration(kDefaultAnimationDuration) { () -> Void in
            self.openUnitsView.alpha = active ? 0.0 : 1.0
            self.inUseView.alpha = active ? 0.0 : 1.0
            self.activeRentalView.alpha = active ? 1.0 : 0.0
            
            self.ctaButton.setTitle(active ? "Unlock" : "Reserve", forState: .Normal)
            
            self.navigationItem.setRightBarButtonItem(UIBarButtonItem(title: "Check Out", style: .Done, target: self, action: "checkOut"), animated: false)
        }

    }
    
    func formatMapViewHeight() {
        let availableScreenHeight = ScreenUtils.screenHeight - navigationController!.navigationBar.frame.size.height - UIApplication.sharedApplication().statusBarFrame.height - buttonHeightConstraint.constant
        let mapViewHeight = ScreenUtils.screenWidth/2 + detailsBarHeightConstraint.constant + 200
        let finalHeight = max(availableScreenHeight, mapViewHeight)
        mapHeightConstraint.constant = finalHeight
    }
    
    func mapViewDidStartTileRendering(mapView: GMSMapView!) {
        // only display marker once tiles have rendered
        let hubMarker = MapManager.customMarkerWithLatitude(hub!.lat!, longitude: hub!.long!, title: hub!.name!, snippet: "Tap for directions")
        hubMarker.map = mapView
    }
    
    func getHubInfo() {
        WebClient.getHubInfo(hub!.uid!) { (response) -> Void in
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
            let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: hub!.lat!, longitude: hub!.long!), addressDictionary: nil))
            destination.name = hub!.name!
            MKMapItem.openMapsWithItems([destination], launchOptions: nil)
        }
    }
    
    private func gmsUrl() -> String {
        let kGMSUrlSchema = "comgooglemaps://?"
        let kHubLocationString = String(hub!.lat!) + "," + String(hub!.long!)
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
    
    func makeReservation() {
        WebClient.makeReservation(hub!.uid!, completion: { (response) -> Void in
            self.performSegueWithIdentifier("reserveSegue", sender: response)
            }) { (error) -> Void in
                //TODO: handle error
        }
    }
    
    func checkOut() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func ctaPressed(sender: AnyObject) {
        if self.displayMode == .PreRental {
            
            // RESERVE
            
            let confirmReservationAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Destructive) { (action) -> Void in
                self.makeReservation()
            }
            let alert = UIAlertController(title: "Confirm Reservation", message: "Reserve a locker in " + hub!.name! + "? Your unit will be held for 20 minutes.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(confirmReservationAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            
            // UNLOCK
            
            let confirmUnlockAction = UIAlertAction(title: "Unlock", style: UIAlertActionStyle.Destructive) { (action) -> Void in
                self.unlock()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                //cancel
            })
            
            let alert = UIAlertController(title: "Confirm Unlock", message: "Are you sure you wish to unlock the unit? You will have 10 seconds to open the locker.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(confirmUnlockAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

    }
    
    func unlock() {
        WebClient.unlockLocker(hub!.uid!, lockerId: rental!.lockerId!, completion: { (response) -> Void in
            // completion
            self.initiateOpenLockerView()
            
            }) { (error) -> Void in
                // error
                self.displayError("Could not open locker. Please try again soon.")
        }
    }
}
