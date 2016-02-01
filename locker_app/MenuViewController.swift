//
//  ViewController.swift
//  locker_app
//
//  Created by Ali Hyder on 1/22/16.
//  Copyright © 2016 Ali Hyder. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.hidesBackButton = true
        
        let backButton = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.Plain, target: self, action: "pop")
        self.navigationItem.leftBarButtonItem = backButton
        
        self.navigationItem.title = "Menu"
        
        //set view background color
        self.view.backgroundColor = Colors.mapBackgroundColor
        
        // setup buttons
        let buttonWidth = 250 as CGFloat
        let buttonHeight = 60 as CGFloat
        let buttonOffset = buttonHeight + 10 as CGFloat
        
        // create account button overlay
        let accountButton = ScreenUtils.primaryButtonWithTitle("Account")
        accountButton.frame = CGRectMake(ScreenUtils.screenWidth/2 - buttonWidth/2, ScreenUtils.screenHeight/2 - buttonHeight/2 - 2*buttonOffset,buttonWidth, buttonHeight)
        accountButton.addTarget(self, action: "performAccountSegue", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(accountButton)
        
        // create payment button overlay
        let paymentButton = ScreenUtils.primaryButtonWithTitle("Payment")
        paymentButton.frame = CGRectMake(ScreenUtils.screenWidth/2 - buttonWidth/2, ScreenUtils.screenHeight/2 - buttonHeight/2 - buttonOffset, buttonWidth, buttonHeight)
        //paymentButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(paymentButton)
        
        // create settings button overlay
        let settingsButton = ScreenUtils.primaryButtonWithTitle("Settings")
        settingsButton.frame = CGRectMake(ScreenUtils.screenWidth/2 - buttonWidth/2, ScreenUtils.screenHeight/2 - buttonHeight/2, buttonWidth, buttonHeight)
        //settingsButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(settingsButton)
        
        // create help button overlay
        let helpButton = ScreenUtils.primaryButtonWithTitle("Help")
        helpButton.frame = CGRectMake(ScreenUtils.screenWidth/2 - buttonWidth/2, ScreenUtils.screenHeight/2 - buttonHeight/2 + buttonOffset, buttonWidth, buttonHeight)
        //helpButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(helpButton)
        
        // create about button overlay
        let aboutButton = ScreenUtils.primaryButtonWithTitle("About")
        aboutButton.frame = CGRectMake(ScreenUtils.screenWidth/2 - buttonWidth/2, ScreenUtils.screenHeight/2 - buttonHeight/2 + 2*buttonOffset, buttonWidth, buttonHeight)
        //aboutButton.addTarget(self, action: "performMenuSegue", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(aboutButton)
    }
    
    func pop() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.navigationController?.view.layer.addAnimation(transition, forKey: nil)
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performAccountSegue() {
        performSegueWithIdentifier("accountSegue", sender: nil)
    }
    
    
}

