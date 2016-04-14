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

let kCountdownTime = 15
let kSecondsToExpiration = 20 * 60 //20 minutes

enum DisplayMode {
    case ActiveRental
    case Reservation
    case PreRental
}

enum LockerStatus {
    case Open
    case Closed
}

class LockerHubViewController : UIViewController, GMSMapViewDelegate {

    @IBOutlet var translucentView: UIView!
    @IBOutlet var reservationCountdown: UILabel!
    @IBOutlet var reservationView: UIView!
    
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
    @IBOutlet var openLockerImage: UIImageView!
    @IBOutlet var openLockerTitle: UILabel!
    @IBOutlet var openLockerView: UIView!
    @IBOutlet var countdownContainer: UIView!
    @IBOutlet var countdownLabel: UILabel!
    var openLockerTimestamp: Int! = nil
    var openLockerStatus: LockerStatus = .Closed

    @IBOutlet weak var detailsBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    var openLockerTimer: NSTimer!
    var reservationTimer: NSTimer!
    var rateTimer: NSTimer!
    
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
                self.displayMode = rental?.status == .Reserved ? .Reservation : .ActiveRental
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
        self._rental = rental
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
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getHubInfo", userInfo: nil, repeats: true)
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
        self.openLockerTitle.text = "LOCKER UNLOCKED"
        
        openLockerImage.image = UIImage(named: "unlock")?.imageWithRenderingMode(.AlwaysTemplate)
        openLockerImage.tintColor = UIColor.whiteColor()
        openLockerImage.alpha = 0
        countdownLabel.alpha = 1
        
        UIView.animateWithDuration(kDefaultAnimationDuration) { () -> Void in
            self.openLockerView.alpha = 1
        }
        
        updateTimer()
        openLockerTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
    }
    
    func dismissOpenLockerView() {
        
        UIView.animateWithDuration(kDefaultAnimationDuration, animations: { () -> Void in
            self.openLockerImage.alpha = 0
            self.openLockerView.alpha = 0
            }) { (completed) -> Void in
                self.openLockerView.hidden = true
                self.displayMessage("Unit locked", message: "Your unit has automatically re-locked.")
        }
        if openLockerTimer != nil {
            openLockerTimer.invalidate()
            openLockerTimer = nil
            openLockerTimestamp = nil
        }

    }
    
    func updateTimer() {
        WebClient.lockerDoorStatus(rental!.hubId!, lockerId: rental!.lockerId!, completion: { (response) -> Void in
            if response["status"] == "OPEN" {
                self.openLockerStatus = .Open
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.openLockerTitle.text = "DOOR OPEN"
                    self.countdownLabel.alpha = 0
                    self.openLockerImage.alpha = 1
                })
            } else {
                self.openLockerStatus = .Closed
                
//                var elapsedTime = 0
//                if let stamp = self.openLockerTimestamp {
//                    elapsedTime = Int(NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: Double(stamp))))
//                }
//                let remainingTime = kCountdownTime - elapsedTime
//                
//                if remainingTime <= 0 {
//                    self.dismissOpenLockerView()
//                }
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.openLockerTitle.text = "LOCKER UNLOCKED"
                    self.countdownLabel.alpha = 1
                    self.openLockerImage.alpha = 0
                })
            }
            }) { (error) -> Void in
                //fail silently, but dismiss view if locker was previously open
                if self.openLockerStatus == .Open {
                    self.dismissOpenLockerView()
                }
        }
        
        
        var elapsedTime = 0
        if let stamp = openLockerTimestamp {
            elapsedTime = Int(NSDate().timeIntervalSinceDate(NSDate(timeIntervalSince1970: Double(stamp))))
        }
        let remainingTime = kCountdownTime - elapsedTime
        
        if remainingTime <= 0 {
            if openLockerStatus == .Closed {
                dismissOpenLockerView()
            }
        } else {
            countdownLabel.text = String(remainingTime)
        }
    }
    
    func checkForActiveRental() {
        RentalManager.checkForActiveRental(hub!.uid!, completion: { (rental) -> Void in
            self.rental = rental
            self.calculateRate()
            self.rateTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateRate", userInfo: nil, repeats: true)
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
        print(String(format: "Calculating rate until date: %@", String(Int(NSDate().timeIntervalSince1970))))
        if rental != nil {
            let elapsedHours = NSDate().timeIntervalSinceDate(rental!.checkInTime!) / kSecondsPerHour
            let runningTotal = hub!.baseRate! + (hub!.hourlyRate! * elapsedHours)
            self.runningTotal.text = String(format:"$%.2f", runningTotal)
        }
    }
    
    func updateDisplay() {
        let active = displayMode == .ActiveRental || displayMode == .Reservation
        
        if active {
            activeAlertLabel.text = "LOCKER #" + String(rental!.lockerId!)
        }

        UIView.animateWithDuration(kDefaultAnimationDuration) { () -> Void in
            self.openUnitsView.alpha = active ? 0.0 : 1.0
            self.inUseView.alpha = active ? 0.0 : 1.0
            self.activeRentalView.alpha = active ? 1.0 : 0.0
            
            self.reservationView.alpha = self.displayMode == .Reservation ? 0.85 : 0.0
            self.translucentView.alpha = self.displayMode == .Reservation ? 0.0 : 0.85
            
            var barButton: UIBarButtonItem! = nil
            var ctaTitle: String! = nil
            
            switch self.displayMode {
            case .ActiveRental:
                barButton = UIBarButtonItem(title: "Check Out", style: .Done, target: self, action: "checkOut")
                ctaTitle = "Unlock"
            case .Reservation:
                barButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelReservation")
                ctaTitle = "Begin Rental"
            default:
                ctaTitle = "Rent"
            }
            
            self.ctaButton.setTitle(ctaTitle, forState: .Normal)
            self.navigationItem.setRightBarButtonItem(barButton, animated: false)
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
            
            if let rental = Rental.fromJSON(response) {
                self.initWithRental(rental)
                self.initReservationTimer()
                self.displayMode = .Reservation
            } else {
                self.displayError("An error occurred processing your rental. Please contact support for assistance.")
            }
            
            }) { (error) -> Void in
                self.displayError("We were unable to complete your reservation request. Please try again soon.")
        }
    }
    
    func initReservationTimer() {
        updateReservationTimer()
        reservationTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateReservationTimer", userInfo: nil, repeats: true)
    }
    
    func updateReservationTimer() {
        let timeIn = rental!.reservationTime!
        let elapsedSeconds = NSDate().timeIntervalSinceDate(timeIn)
        let remainingSeconds = kSecondsToExpiration - Int(elapsedSeconds)
        
        if remainingSeconds <= 0 {
            displayMessage("Reservation Expired", message: "Your reservation expired after 20 minutes.")
            reservationTimer.invalidate()
            reservationTimer = nil
            rental = nil
            return
        }
        
        let minutesPlace = remainingSeconds / 60
        let secondsPlace = remainingSeconds % 60
        
        let timeString = String(format: "%02d:%02d", minutesPlace, secondsPlace)
        reservationCountdown.text = timeString
    }
    
    func checkOut() {
        view.userInteractionEnabled = false
        navigationController?.navigationBar.userInteractionEnabled = false
        WebClient.endRental(rental!.uid!, completion: { (response) -> Void in
            self.view.userInteractionEnabled = true
            self.navigationController?.navigationBar.userInteractionEnabled = true
            self.rental = nil
            if self.rateTimer != nil {
                self.rateTimer.invalidate()
                self.rateTimer = nil
            }
            self.displayMessage("Success!", message: "Your rental was successfully ended.", completion: { () -> Void in
                self.performSegueWithIdentifier("checkOutSegue", sender: nil)
            })
            }) { (error) -> Void in
                self.view.userInteractionEnabled = true
                self.navigationController?.navigationBar.userInteractionEnabled = true
                self.displayError("An error occurred ending your rental. Please contact support for assistance.");
        }
    }
    
    @IBAction func ctaPressed(sender: AnyObject) {
        
        switch self.displayMode {
        case .ActiveRental:
            
            // UNLOCK
            
            let confirmUnlockAction = UIAlertAction(title: "Unlock", style: UIAlertActionStyle.Destructive) { (action) -> Void in
                self.unlock()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                //cancel
            })
            
            let alert = UIAlertController(title: "Confirm Unlock", message: "Are you sure you wish to unlock the unit? You will have "+String(kCountdownTime)+" seconds to open the locker.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(confirmUnlockAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        case .Reservation:
            
            // CHECK IN
            let beginRentalAction = UIAlertAction(title: "Begin Rental", style: UIAlertActionStyle.Destructive) { (action) -> Void in
                
                let hubLocation = CLLocation(latitude: self.hub!.lat!, longitude: self.hub!.long!)
                
                // if the user is >20 mi from the hub, make them confirm before continuing
                if LocationManager.userLocation()?.distanceFromLocation(hubLocation) > kRentalDistanceAlertThreshold {
                    let confirmLocationAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (action) -> Void in
                        self.beginRental()
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                        //cancel
                    })
                    
                    let alert = UIAlertController(title: "Location Discrepancy", message: "Looks like you're more than 20 miles from this locker. Unless your location is incorrect, you may be at the wrong hub. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(confirmLocationAction)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.beginRental()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                //cancel
            })
            
            let alert = UIAlertController(title: "Begin rental", message: "Are you at your locker hub and ready to begin your rental?", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(beginRentalAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        default:
            
            // RESERVE
            
            let reserveAction = UIAlertAction(title: "Reserve", style: UIAlertActionStyle.Default) { (action) -> Void in
                
                let hubLocation = CLLocation(latitude: self.hub!.lat!, longitude: self.hub!.long!)
                
                // if the user is >20 mi from the hub, make them confirm before continuing
                if LocationManager.userLocation()?.distanceFromLocation(hubLocation) > kRentalDistanceAlertThreshold {
                    let confirmLocationAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (action) -> Void in
                        self.makeReservation()
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                        //cancel
                    })
                    
                    let alert = UIAlertController(title: "Location Discrepancy", message: "We've detected you're more than 20 miles away from this hub; it'll be difficult to make it in time for your reservation. Are you sure you want to continue? ", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(confirmLocationAction)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.makeReservation()
                }
                
            }
            
            let rentAction = UIAlertAction(title: "Rent Now", style: .Destructive, handler: { (action) -> Void in
                
                let hubLocation = CLLocation(latitude: self.hub!.lat!, longitude: self.hub!.long!)
                
                // if the user is >20 mi from the hub, make them confirm before continuing
                if LocationManager.userLocation()?.distanceFromLocation(hubLocation) > kRentalDistanceAlertThreshold {
                    let confirmLocationAction = UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default) { (action) -> Void in
                        self.beginRental()
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                        //cancel
                    })
                    
                    let alert = UIAlertController(title: "Location Discrepancy", message: "Looks like you're more than 20 miles from this locker. Unless your location is incorrect, you may be at the wrong hub. Are you sure you want to continue?", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(confirmLocationAction)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    self.beginRental()
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
                //cancel
            })
            
            let alert = UIAlertController(title: "Choose Rental Option", message: "Rent a locker immediately at " + hub!.name! + "? Or make a reservation? Reserved lockers will be held for 20 minutes.", preferredStyle: UIAlertControllerStyle.ActionSheet)
            alert.addAction(rentAction)
            alert.addAction(reserveAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

    }
    
    func cancelReservation() {
        WebClient.endRental(rental!.uid!, completion: { (response) -> Void in
            self.rental = nil
            self.displayMessage("Success!", message: "Your reservation was cancelled.")
            }) { (error) -> Void in
                self.displayError("An error occurred cancelling your reservation. Please contact support for assistance.");
        }
    }
    
    func beginRental() {
        WebClient.beginRental(rental?.uid, hubId: hub!.uid!, completion: { (response) -> Void in
            if self.reservationTimer != nil {
                self.reservationTimer.invalidate()
                self.reservationTimer = nil
            }
            self.rental = Rental.fromJSON(response)
            self.calculateRate()
            
            self.openLockerTimestamp = response["checkInTime"] as! Int
            self.initiateOpenLockerView()
            
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateRate", userInfo: nil, repeats: true)
            }) { (error) -> Void in
                self.displayError("An error occurred processing your rental request. Please contact support for assistance.")
        }
    }
    
    func unlock() {
        WebClient.unlockLocker(rental!.uid!, completion: { (response) -> Void in
            
            self.openLockerTimestamp = response["timestamp"] as! Int
            self.initiateOpenLockerView()
            
            }) { (error) -> Void in
                // error
                self.displayError("Could not open locker. Please try again soon.")
        }
    }
}
