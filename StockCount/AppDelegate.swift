//
//  AppDelegate.swift
//  StockCount
//
//  Created by Sohel Dhanani on 12/23/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import AVFoundation
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import CaptureSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    AppCenter.start(
      withAppSecret: "3f7aba1a-0d62-4281-908c-68590b513971",
      services: [
        Analytics.self,
        Crashes.self,
      ])

    retrieveSecKeyValues()

    // Initialize CaptureHelper
    let AppInfo = SKTAppInfo()
    AppInfo.appKey = "MCwCFDqSvrhLenQ9qu49ADSL3K+9mWV8AhQIamqcj1fjbGZVcJ3r+t5ijm+/ow=="
    AppInfo.appID = "ios:com.socketmobile.stockCount"

    AppInfo.developerID = "BB57D8E1-F911-47BA-B510-693BE162686A"

    let captureHelper = CaptureHelper.sharedInstance
    captureHelper.dispatchQueue = DispatchQueue.main

    captureHelper.openWithAppInfo(AppInfo) { (result: SKTResult) in
      print("Result of Capture initialization: \(result.rawValue)")

      captureHelper.setConfirmationMode(
        .modeDevice,
        withCompletionHandler: { (result) in
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

  func application(
    _ application: UIApplication,
    shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication
      .ExtensionPointIdentifier
  ) -> Bool {
    if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
      return false
    }

    return true
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    try? AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
  }
}
