//
//  AppDelegate.swift
//  StockCount
//
//  Created by Sohel Dhanani on 12/23/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import UIKit
import Fabric
import Crashlytics

import SKTCapture
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        // Initialize CaptureHelper
        let AppInfo = SKTAppInfo()
    AppInfo.appKey="MCwCFDqSvrhLenQ9qu49ADSL3K+9mWV8AhQIamqcj1fjbGZVcJ3r+t5ijm+/ow=="
        AppInfo.appID="ios:com.socketmobile.stockCount"

        AppInfo.developerID="BB57D8E1-F911-47BA-B510-693BE162686A"
        
        let captureHelper = CaptureHelper.sharedInstance
        captureHelper.dispatchQueue = DispatchQueue.main
        
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
        try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

