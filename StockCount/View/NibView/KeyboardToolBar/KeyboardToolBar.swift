//
//  KeyboardToolBar.swift
//  StockCount
//
//  Created by Sohel Dhanani on 2/12/18.
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

class KeyboardToolBar : NibView {
    
    let captureHelper = CaptureHelper.sharedInstance
    
    @IBOutlet weak var btnKeytype: UIButton!
    @IBOutlet weak var btnConnection: UIButton!
    
    weak var delegate : KeyboardToolBarDelegate? = nil
    
    func updateConnection(isConnected : Bool) {
        let imgName = isConnected ? "scanner_connected" : "scanner_disconnected"
        if let img = UIImage(named: imgName) {
            btnConnection.setBackgroundImage(img, for: .normal)
        }
    }
    
    func setKeyboardTitle(_ title:String) {
        btnKeytype.setTitle(title, for: .normal)
    }
    //MARK: - Events
    
    @IBAction func onBtnScan(_ sender: Any) {
        delegate?.didTriggerScan()
    }
    
    
    @IBAction func onBtnSwitchKeyboard(_ sender: Any) {
        delegate?.didSwitchKeyboard()
    }
    
}
