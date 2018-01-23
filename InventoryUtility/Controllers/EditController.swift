//
//  EditController.swift
//  InventoryUtility
//
//  Created by IT Star on 1/14/18.
//  Copyright © 2018 Simple Design Inc. All rights reserved.
//

import Foundation
import SKTCapture

protocol EditControllerProtocol {
    func readFile(_ fileName : String)
    func saveFile(_ fileName : String, strContent : String)
    func removeFile(_ fileName : String)
    
    func setSoftScan(_ isSet : Bool)
    func startScan()
    func stopScan()
}

class EditController : CaptureHelperDeviceDecodedDataDelegate, EditControllerProtocol,
//                    CaptureHelperDeviceManagerDiscoveryDelegate,
                    CaptureHelperDeviceManagerPresenceDelegate,
                    CaptureHelperDevicePresenceDelegate{
    let captureHelper = CaptureHelper.sharedInstance
    var deviceManager : CaptureHelperDeviceManager? = nil
    var viewer : EditViewProtocol?
    
    private var isScanning = false
    private var isSoftScan = false
    
    init(view : EditViewProtocol? = nil) {
        viewer = view
        
        let AppInfo = SKTAppInfo()
        AppInfo.appKey="MC0CFHPYIb54AaQQ0h90lh6iOTzSi38nAhUA4nA2VM8Dim+NAnTDKwx+BOCr4p0="
        AppInfo.bundleID="ios:com.socketmobile.inventoryCounting";
        AppInfo.developerID="EF62BC15-59E0-4E86-82A3-493101D7DB4E"
        // open Capture Helper only once in the application
        
        captureHelper.delegateDispatchQueue = DispatchQueue.main
        captureHelper.pushDelegate(self)
        
        captureHelper.openWithAppInfo(AppInfo) { (result: SKTResult) in
            print("Result of Capture initialization: \(result.rawValue)")
            
            self.captureHelper.setConfirmationMode(.modeDevice, withCompletionHandler: { (result) in
                print("Data Confirmation Mode returns : \(result.rawValue)")
            })
            
            self.captureHelper.setSoftScanStatus(.disable, withCompletionHandler: { (result) in
                print("Soft Scan Disabled \(result.rawValue)")
            })
            
            let deviceMgrList = self.captureHelper.getDeviceManagers()
            if deviceMgrList.count > 0 {
                deviceMgrList[0].setFavoriteDevices("*", withCompletionHandler: { (result: SKTResult) in
                    print("Result of Auto Scan")
                })
            }
            
        }
    }
    
    deinit {
        captureHelper.popDelegate(self)
    }
    //MARK: - EditControllerProtocol
    func readFile(_ fileName: String) {
        let strContent = FileMgr.readFile(fileName: fileName)
        viewer?.showFileContent(strContent: strContent)
    }
    
    func saveFile(_ fileName: String, strContent: String) {
        FileMgr.saveFile(fileName: fileName, content: strContent)
    }
    
    func removeFile(_ fileName: String){
        FileMgr.deleteFile(fileName: fileName)
    }
    
    func setSoftScan(_ isSet: Bool = true) {
        isSoftScan = true
        
        captureHelper.setSoftScanStatus(.enable) { (result) in
            print("Setting softscan to supported returned \(result.rawValue)")
        }
        
    }
    func startScan() {
        /*let deviceMgrList = captureHelper.getDeviceManagers()
        if deviceMgrList.count > 0 {
            isScanning = true
            deviceMgrList[0].startDiscoveryWithTimeout(5000, withCompletionHandler: { (result : SKTResult) in
                print("Discovering Result : \(result)")
                
                if result == SKTResult.E_NOERROR {
                    DispatchQueue.main.async {
                        self.viewer?.showScangDlg()
                    }
                }
                
            })
        }*/
        
        if captureHelper.getDevices().count < 1 {
            //No devices Connected.
            self.viewer?.showCompanionDlg()
        }
    }
    
    func stopScan() {
        captureHelper.popDelegate(self)
    }
    
    //MARK: - CaptureHelperDeviceDecodedDataDelegate Delegate
    func didReceiveDecodedData(_ decodedData: SKTCaptureDecodedData?, fromDevice device: CaptureHelperDevice, withResult result: SKTResult) {
        if result == SKTCaptureErrors.E_NOERROR {
            let rawData = decodedData?.decodedData
            let rawDataSize = rawData?.count
            print("Size: \(String(describing: rawDataSize))")
            print("data: \(String(describing: decodedData?.decodedData))")
            let string = decodedData?.stringFromDecodedData()!
            print("Decoded Data \(String(describing: string))")
            
            // here we can update the UI directly because we set
            // the deleteDispatchQueue Capture Helper property to DispatchQueue.main
            if let readData = rawData {
                if let readStr = String(data: readData, encoding: .utf8) {
                    viewer?.addScanData(strLine: readStr)
                }
            }
        }
    }
    
    //MARK: - CaptureHelperDeviceManagerDiscoveryDelegate
    /*func didDiscoverDevice(_ device: String, fromDeviceManager deviceManager: CaptureHelperDeviceManager) {
        let data  = device.data(using: .utf8)
        let deviceInfo = try! PropertyListSerialization.propertyList(from:data!, options: [], format: nil) as! [String:Any]
        print("device discover: \(deviceInfo)")
        deviceManager.setFavoriteDevices(deviceInfo["identifierUUID"] as! String) { (result) in
            print("setting the favorite devices returns: \(result.rawValue)")
        }
    }
    
    func didEndDiscoveryWithResult(_ result: SKTResult, fromDeviceManager deviceManager: CaptureHelperDeviceManager) {
        print("Did End Discovery Result = \(result)")
        
        DispatchQueue.main.async {
            self.viewer?.closeScanDlg()
        }
        
        let deviceList = captureHelper.getDevices()
        if deviceList.count < 1 {
            DispatchQueue.main.async {
                self.viewer?.showCompanionDlg()
            }
        }
        
    }*/
    
    //MARK: - DeviceManager Presence Delegate
    func didNotifyArrivalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        print("DEvice Manager Arrival Notification")
        
        deviceManager = device
        
        device.getFavoriteDevicesWithCompletionHandler { (result, favorites) in
            print("getting the favorite devices returned \(result.rawValue)")
            if result == .E_NOERROR {
                if let fav = favorites as String! {
                    if fav.isEmpty {
                        device.setFavoriteDevices("*", withCompletionHandler: { (result) in
                            print("Setting new favorites returned \(result.rawValue)")
                        })
                    }
                }
            }
        }
    }
    
    func didNotifyRemovalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        
    }
    
    //MARK: - CaptureHelperDevicePresenceDelegate
    func didNotifyArrivalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        device.getDataAcknowledgmentWithCompletionHandler { (result, dataAcknowledgement) in
            
        }
        
        let name = device.deviceInfo.name
        if name?.caseInsensitiveCompare("SoftScanner") == ComparisonResult.orderedSame {
            
            if let viewContext = self.viewer?.getOverlayContextForSoftScan() {
                let context : [String:Any] = [SKTCaptureSoftScanContext : viewContext]
                device.setSoftScanOverlayViewParameter(context, withCompletionHandler: { (result) in
                    print("Set soft scan overlay result : \(result.rawValue)")
//                    self.viewer?.showAlert("Set SoftScan Overlay result : \(result.rawValue)")
                    
                    device.setTrigger(.start, withCompletionHandler: { (result) in
                        print("Starting soft scan result : \(result.rawValue)")
//                        self.viewer?.showAlert("SoftScan Started : \(result.rawValue)")
                    })
                })
            }
        }
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        
    }
    
}
