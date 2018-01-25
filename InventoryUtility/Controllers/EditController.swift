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
    //    func stopScan()
}

enum EnumScanMode {
    case none
    case deviceScan
    case softScan
}

class EditController : CaptureHelperDeviceDecodedDataDelegate, EditControllerProtocol,
    CaptureHelperDeviceManagerPresenceDelegate,
CaptureHelperDevicePresenceDelegate {
    
    var viewer : EditViewProtocol?
    
    var guidList : [String] = []
    
    let captureHelper = CaptureHelper.sharedInstance
    
    private var scanMode : EnumScanMode = .none
    private var softScanner : CaptureHelperDevice? = nil
    
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
        scanMode = .softScan
        //Starting SoftScan
        captureHelper.setSoftScanStatus(.enable) { (result) in
            print("Setting softscan to supported returned \(result.rawValue)")
        }
        
    }
    func startScan() {
        if scanMode == .softScan {
            softScanner?.setTrigger(.start, withCompletionHandler: { (result) in
                print("Start Soft Scan Overlay : \(result.rawValue)")
            })
        } else {
            //            if captureHelper.getDevices().count < 1
            if guidList.count < 1 {
                scanMode = .none
                self.viewer?.showCompanionDlg()
            } else {
                scanMode = .deviceScan
            }
        }
    }
    
    /*func stopScan() {
     captureHelper.popDelegate(self)
     }*/
    
    //MARK: - CaptureHelperDeviceDecodedDataDelegate Delegate
    func didReceiveDecodedData(_ decodedData: SKTCaptureDecodedData?, fromDevice device: CaptureHelperDevice, withResult result: SKTResult) {
        
        print("Decoded data arrived")
        
        if result == SKTCaptureErrors.E_NOERROR {
            
            if scanMode != .none {
                let rawData = decodedData?.decodedData
                let rawDataSize = rawData?.count
                print("Size: \(String(describing: rawDataSize))")
                print("data: \(String(describing: decodedData?.decodedData))")
                let string = decodedData?.stringFromDecodedData()!
                print("Decoded Data \(String(describing: string))")
                
                // here we can update the UI directly because we set
                // the deleteDispatchQueue Capture Helper property to DispatchQueue.main
                if let readData = rawData {
                    if let readBarcode = String(data: readData, encoding: .utf8) {
                        
                        let newLineStr = SettingMgr.getLineForBarcode(readBarcode)
                        viewer?.addScanData(strLine: newLineStr)
                    }
                }
            }
        }
    }
    
    //MARK: - DeviceManager Presence Delegate
    func didNotifyArrivalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        print("DEvice Manager Arrival Notification")
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
            print("GetDataAcknowledgement : \(result.rawValue)")
            //            if let curAck = dataAcknowledgement, curAck == .off {
            //                device.setDataAcknowledgment(.on, withCompletionHandler: { (result) in
            //                    print("Set Device dataAcknowledgement result \(result.rawValue)")
            //                })
            //            }
        }
        
        let name = device.deviceInfo.name
        
        print("Device Arrival = \(name)")
        
        if name?.caseInsensitiveCompare("SoftScanner") == ComparisonResult.orderedSame {
            
            softScanner = device
            if let viewContext = self.viewer?.getOverlayContextForSoftScan() {
                let context : [String:Any] = [SKTCaptureSoftScanContext : viewContext]
                device.setSoftScanOverlayViewParameter(context, withCompletionHandler: { (result) in
                    print("Set soft scan overlay result : \(result.rawValue)")
                    
                    device.setTrigger(.start, withCompletionHandler: { (result) in
                        print("Starting soft scan result : \(result.rawValue)")
                    })
                })
            }
        } else {
            if let guid = device.deviceInfo.guid, !guidList.contains(guid) {
                guidList.append(guid)
            }
        }
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        
        let name = device.deviceInfo.name
        if name?.caseInsensitiveCompare("SoftScanner") == ComparisonResult.orderedSame {
            softScanner = nil
        } else {
            if let guid = device.deviceInfo.guid, let itemIndex = guidList.index(of: guid) {
                guidList.remove(at: itemIndex)
            }
        }
    }
    
}

