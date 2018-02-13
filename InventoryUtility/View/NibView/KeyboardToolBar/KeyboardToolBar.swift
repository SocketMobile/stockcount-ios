//
//  KeyboardToolBar.swift
//  InventoryUtility
//
//  Created by IT Star on 2/12/18.
//  Copyright © 2018 Socket Mobile Inc.
//

import Foundation
import UIKit
import SKTCapture

protocol KeyboardToolBarDelegate : class {
    func didTriggerScan()
    func didSwitchKeyboard()
}

extension KeyboardToolBarDelegate {
    func didTriggerScan() {}
    func didSwitchKeyboard() {}
}

class KeyboardToolBar : NibView, CaptureHelperDevicePresenceDelegate {
    
    let captureHelper = CaptureHelper.sharedInstance
    var connectedDeviceCount = 0
    
    
    @IBOutlet weak var btnKeytype: UIButton!
    @IBOutlet weak var btnConnection: UIButton!
    
    weak var delegate : KeyboardToolBarDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        captureHelper.pushDelegate(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        captureHelper.pushDelegate(self)
    }
    
    deinit {
        captureHelper.popDelegate(self)
    }
    
    private func updateConnection() {
        let imgName = connectedDeviceCount > 0 ? "scanner_connected" : "scanner_disconnected"
        if let img = UIImage(named: imgName) {
            btnConnection.setBackgroundImage(img, for: .normal)
        }
    }
    
    func setKeyboardTitle(_ title:String) {
        btnKeytype.setTitle(title, for: .normal)
    }
    
    //MARK: - CaptureHelperDevicePresence Delegate
    func didNotifyArrivalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        let name = device.deviceInfo.name
        if name?.caseInsensitiveCompare("SoftScanner") != ComparisonResult.orderedSame {
            connectedDeviceCount += 1
            updateConnection()
        }
    }
    
    func didNotifyRemovalForDevice(_ device: CaptureHelperDevice, withResult result: SKTResult) {
        let name = device.deviceInfo.name
        if name?.caseInsensitiveCompare("SoftScanner") != ComparisonResult.orderedSame {
            connectedDeviceCount -= 1
            if connectedDeviceCount < 0 {
                connectedDeviceCount = 0
            }
            updateConnection()
        }
    }
    
    //MARK: - Events
    
    @IBAction func onBtnScan(_ sender: Any) {
        delegate?.didTriggerScan()
    }
    
    
    @IBAction func onBtnSwitchKeyboard(_ sender: Any) {
        delegate?.didSwitchKeyboard()
    }
    
}
