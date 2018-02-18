//
//  AppDelegate.swift
//  InventoryUtility
//
//  Created by IT Star on 12/23/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import UIKit
import Fabric
import Crashlytics

import SKTCapture

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        // Initialize CaptureHelper
        let AppInfo = SKTAppInfo()
        AppInfo.appKey="MC0CFHPYIb54AaQQ0h90lh6iOTzSi38nAhUA4nA2VM8Dim+NAnTDKwx+BOCr4p0="
        AppInfo.bundleID="ios:com.socketmobile.inventoryCounting";
        AppInfo.developerID="EF62BC15-59E0-4E86-82A3-493101D7DB4E"
        
        let captureHelper = CaptureHelper.sharedInstance
        captureHelper.delegateDispatchQueue = DispatchQueue.main
        
        captureHelper.openWithAppInfo(AppInfo) { (result: SKTResult) in
            print("Result of Capture initialization: \(result.rawValue)")
            
            captureHelper.setConfirmationMode(.modeDevice, withCompletionHandler: { (result) in
                print("Data Confirmation Mode returns : \(result.rawValue)")
            })
        }
        
        if UserDefaults.standard.object(forKey: "isStarted") == nil {
            let storyBoard = UIStoryboard(name: "Instruction", bundle: nil)
            let viewController = storyBoard.instantiateInitialViewController()
            
            window?.rootViewController = viewController
        }
        
        return true
    }

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

