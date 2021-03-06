//
//  AppDelegate.swift
//  PDM-MobileHub
//
//  Created by Nick Grah on 1/21/18.
//  Copyright © 2018 PDM. All rights reserved.
//

import UIKit
import AWSMobileClient
import AWSCore
import AWSPinpoint
import AWSAuthCore
import AWSUserPoolsSignIn


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // aws logger code, not working right now
    //AWSDDLog.add(AWSDDTTYLogger.sharedInstance)
    //AWSDDLog.sharedInstance.logLevel = .info
    
    var pinpoint: AWSPinpoint?
    var isInitialized: Bool = false
    
//************************************************************************
    
    // initialize with mobile client
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        AWSSignInManager.sharedInstance().interceptApplication(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        isInitialized = true
        
        return true
    
    }
    
//************************************************************************

    // initialize with mobile client and pinpoint
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AWSSignInManager.sharedInstance().register(signInProvider: AWSCognitoUserPoolsSignInProvider.sharedInstance())
        let didFinishLaunching = AWSSignInManager.sharedInstance().interceptApplication(application, didFinishLaunchingWithOptions: launchOptions)
        
        pinpoint = AWSPinpoint(configuration:AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: launchOptions))
        if (!isInitialized) {
            AWSSignInManager.sharedInstance().resumeSession(completionHandler: { (result: Any?, error: Error?) in
                print("Result: \(result) \n Error:\(error)")
            })
            isInitialized = true
        }
        
        return didFinishLaunching
    }

//************************************************************************
    
    // Pinpoint analytics event
    func logEvent() { let pinpointAnalyticsClient = AWSPinpoint(configuration: AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: nil)).analyticsClient
        
        let event = pinpointAnalyticsClient.createEvent(withEventType: "EventName")
        event.addAttribute("DemoAttributeValue1", forKey: "DemoAttribute1")
        event.addAttribute("DemoAttributeValue2", forKey: "DemoAttribute2")
        event.addMetric(NSNumber.init(value: arc4random() % 65535), forKey: "EventName")
        pinpointAnalyticsClient.record(event)
        pinpointAnalyticsClient.submitEvents()
    }
    
//************************************************************************
    
    //pinpoint monetization analytics event
    func sendMonetizationEvent()
    {
        let pinpointClient = AWSPinpoint(configuration:
            AWSPinpointConfiguration.defaultPinpointConfiguration(launchOptions: nil))
        
        let pinpointAnalyticsClient = pinpointClient.analyticsClient
        
        let event =
            pinpointAnalyticsClient.createVirtualMonetizationEvent(withProductId:
                "DEMO_PRODUCT_ID", withItemPrice: 1.00, withQuantity: 1, withCurrency: "USD")
        pinpointAnalyticsClient.record(event)
        pinpointAnalyticsClient.submitEvents()
    }

//************************************************************************
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

