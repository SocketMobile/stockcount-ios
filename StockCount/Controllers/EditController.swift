//
//  EditController.swift
//  StockCount
//
//  Created by IT Star on 1/14/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import SKTCapture

protocol EditControllerProtocol {
    func readFile(_ fileName : String)
    func saveFile(_ fileName : String, strContent : String)
    func removeFile(_ fileName : String)
    
    func triggerScan()
}

class EditController : CaptureHelperDeviceDecodedDataDelegate, EditControllerProtocol,
    CaptureHelperDeviceManagerPresenceDelegate,
CaptureHelperDevicePresenceDelegate {
    
    var viewer : EditViewProtocol?
    
    let captureHelper = CaptureHelper.sharedInstance
    
    var connectedScannerCount = 0
    
    var isSoftScan : Bool = false {
        didSet {
            captureHelper.setSoftScanStatus(isSoftScan ? .enable : .disable) { (result) in
                print("Setting softscan to supported returned \(result.rawValue)")
            }
        }
    }
    
    init(view : EditViewProtocol? = nil) {
        viewer = view
        
        captureHelper.pushDelegate(self)
        
        captureHelper.setSoftScanStatus(.disable, withCompletionHandler: { (result) in
            print("Soft Scan Disabled \(result.rawValue)")
        })
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
        
    func triggerScan() {
        let scannerList = captureHelper.getDevices()
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
        var strFavoriteDevice = ""
        if SettingMgr.supportD600 {
            strFavoriteDevice = "*"
        }
        
        device.setFavoriteDevices(strFavoriteDevice, withCompletionHandler: { (result) in
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
        } else {
            if isSoftScan {
                isSoftScan = false
            }
            connectedScannerCount += 1
            viewer?.notifyScannerConnected(isConnected: true)
        }
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        let name = device.deviceInfo.name
        if name?.caseInsensitiveCompare("SoftScanner") != ComparisonResult.orderedSame {
            connectedScannerCount -= 1
            if connectedScannerCount < 0 {
                connectedScannerCount = 0
            }
            viewer?.notifyScannerConnected(isConnected: connectedScannerCount > 0)
        }
    }
    
}

