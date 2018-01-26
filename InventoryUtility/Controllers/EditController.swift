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
    func triggerScan()
    //    func stopScan()
}

class EditController : CaptureHelperDeviceDecodedDataDelegate, EditControllerProtocol,
    CaptureHelperDeviceManagerPresenceDelegate,
CaptureHelperDevicePresenceDelegate {
    
    var viewer : EditViewProtocol?
    
    var scannerList : [CaptureHelperDevice] = []
    
    let captureHelper = CaptureHelper.sharedInstance
    
    init(view : EditViewProtocol? = nil) {
        viewer = view
        
        let AppInfo = SKTAppInfo()
        AppInfo.appKey="MC0CFHPYIb54AaQQ0h90lh6iOTzSi38nAhUA4nA2VM8Dim+NAnTDKwx+BOCr4p0="
        AppInfo.bundleID="ios:com.socketmobile.inventoryCounting";
        AppInfo.developerID="EF62BC15-59E0-4E86-82A3-493101D7DB4E"
        
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
        //Starting SoftScan
        captureHelper.setSoftScanStatus(isSet ? .enable : .disable) { (result) in
            print("Setting softscan to supported returned \(result.rawValue)")
        }
    }
    
    
    func triggerScan() {
        if scannerList.count < 1 {
            self.viewer?.showCompanionDlg()
        } else {
            for scanner in scannerList {
                scanner.setTrigger(.start, withCompletionHandler: { (result) in
                    print("Start Triggering : \(result.rawValue)")
                })
            }
        }
    }
    
    //MARK: - CaptureHelperDeviceDecodedDataDelegate Delegate
    func didReceiveDecodedData(_ decodedData: SKTCaptureDecodedData?, fromDevice device: CaptureHelperDevice, withResult result: SKTResult) {
        if result == SKTCaptureErrors.E_NOERROR {
            /*let rawData = decodedData?.decodedData
            let rawDataSize = rawData?.count
            print("Size: \(String(describing: rawDataSize))")
            print("data: \(String(describing: decodedData?.decodedData))")*/
            
            if let readData = decodedData?.decodedData {
                if let readBarcode = String(data: readData, encoding: .utf8) {
                    
                    let trimmedData = readBarcode.trimmingCharacters(in: .newlines)
                    let newLineStr = SettingMgr.getLineForBarcode(trimmedData)
                    viewer?.addScanData(strLine: newLineStr)
                }
            }
        }
    }
    
    //MARK: - DeviceManager Presence Delegate
    func didNotifyArrivalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        device.setFavoriteDevices("*", withCompletionHandler: { (result) in
            print("Setting new favorites returned \(result.rawValue)")
        })
    }
    
    func didNotifyRemovalForDeviceManager(_ device: CaptureHelperDeviceManager, withResult result: SKTResult) {
        
    }
    
    //MARK: - CaptureHelperDevicePresenceDelegate
    func didNotifyArrivalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        let name = device.deviceInfo.name
        if name?.caseInsensitiveCompare("SoftScanner") == ComparisonResult.orderedSame {
            if let viewContext = self.viewer?.getOverlayContextForSoftScan() {
                let context : [String:Any] = [SKTCaptureSoftScanContext : viewContext]
                device.setSoftScanOverlayViewParameter(context, withCompletionHandler: { (result) in
                    print("Set soft scan overlay result : \(result.rawValue)")
                    
                    device.setTrigger(.start, withCompletionHandler: { (result) in
                        print("Starting soft scan result : \(result.rawValue)")
                    })
                })
            }
        }
        if !scannerList.contains(device) {
            scannerList.append(device)
        }
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        if let itemIndex = scannerList.index(of: device) {
            scannerList.remove(at: itemIndex)
        }
    }
    
}

