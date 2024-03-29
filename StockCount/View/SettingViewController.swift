//
//  SettingViewController.swift
//  StockCount
//
//  Created by Sohel Dhanani on 1/18/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit
import CaptureSDK

class SettingViewController : CustomNavBarViewController {
    
    @IBOutlet weak var switchAutoQuantity: UISwitch!
    
    @IBOutlet weak var btnContainer: UIView!
    
    @IBOutlet weak var imgCheckQuantityComma: UIImageView!
    @IBOutlet weak var imgCheckQuantityNoComma: UIImageView!
    
    @IBOutlet weak var stepperQuantity: UIStepper!
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var imgCheckNewLine: UIImageView!
    @IBOutlet weak var imgCheckNoNewLine: UIImageView!
    
    @IBOutlet weak var txtPreview: UITextView!
    
    @IBOutlet weak var switchVibrate: UISwitch!
    
    @IBOutlet weak var switchSupportD600: UISwitch!
    
    @IBOutlet weak var switchConsolidatingCounts: UISwitch!
    private func updateBtnCtrlState() {
        btnContainer.isUserInteractionEnabled = SettingMgr.autoAddQuantity
        btnContainer.alpha = SettingMgr.autoAddQuantity ? 1.0 : 0.3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchAutoQuantity.isOn = SettingMgr.autoAddQuantity
        switchSupportD600.isOn = SettingMgr.supportD600
        switchVibrate.isOn = SettingMgr.vibrationOnScan
        switchConsolidatingCounts.isOn = SettingMgr.consolidatingCounts
        showQuantityFormat(SettingMgr.delineatorComma)
        showNewLineFormat(SettingMgr.newLineForNewScan)

        stepperQuantity.value = Double(SettingMgr.defaultQuantity)
        txtQuantity.text = "\(SettingMgr.defaultQuantity)"
        
        updateBtnCtrlState()
        updateTxtPreview()
    }
    
    //MARK: - NavigationBar
    override func initNavBarItems() {
        super.initNavBarItems()
        
        self.navigationItem.leftItemsSupplementBackButton = true
        if let btnOption = createBarButtonFromImage("NavBar_Option", target: self, action: #selector(self.onBtnBack)) {
            self.navigationItem.leftBarButtonItem = btnOption
        }
    }
    
    @objc func onBtnBack() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Automatically Add Quantity
    @IBAction func didAutoQuantityChanged(_ sender: Any) {
        SettingMgr.autoAddQuantity = switchAutoQuantity.isOn
        
        updateBtnCtrlState()
        updateTxtPreview()
    }
    
    //MARK: - Quantity format options
    @IBAction func didQuantityFormatChanged(_ sender: UIButton) {
        let withComma = sender.tag == 1
        SettingMgr.delineatorComma = withComma
        
        showQuantityFormat(withComma)
        updateTxtPreview()
    }
    
    func showQuantityFormat(_ withComma : Bool){
        imgCheckQuantityComma.isHidden = !withComma
        imgCheckQuantityNoComma.isHidden = withComma
    }
    
    //MARK: - Default Quantity
    
    @IBAction func didDefaultQuantityChanged(_ sender: Any) {
        let curDefaultQuantity = Int(stepperQuantity.value)
        
        SettingMgr.defaultQuantity = curDefaultQuantity
        txtQuantity.text = "\(curDefaultQuantity)"
        
        updateTxtPreview()
    }
    
    //Mark: - New Line
    @IBAction func didNewLineSetChanged(_ sender: UIButton) {
        let newLine = sender.tag == 1
        SettingMgr.newLineForNewScan = newLine
        
        showNewLineFormat(newLine)
        updateTxtPreview()
    }
    
    func showNewLineFormat(_ newLine : Bool) {
        imgCheckNewLine.isHidden = !newLine
        imgCheckNoNewLine.isHidden = newLine
    }
    
    //MARK: - TextField
    func updateTxtPreview() {
        var strPreview = "txt_preview".localized
        
        strPreview = strPreview + SettingMgr.getLineForBarcode()
        strPreview = strPreview + SettingMgr.getLineForBarcode()
        
        txtPreview.text = strPreview
    }
    
    //MARK: - Vibrate on Scan
    @IBAction func didVibrationChanged(_ sender: Any) {
        SettingMgr.vibrationOnScan = switchVibrate.isOn
    }
    
    //MARK: - Support D600
    @IBAction func didSupportD600Changed(_ sender: Any) {
        SettingMgr.supportD600 = switchSupportD600.isOn
        
        let strFavorite = switchSupportD600.isOn ? "*" : ""
        
        let capture = CaptureHelper.sharedInstance
        for deviceManager in capture.getDeviceManagers() {
            deviceManager.setFavoriteDevices(strFavorite, withCompletionHandler: { (result) in
                print("DeviceManager set favorite result :\(result.rawValue)")
            })
        }
    }
    
    
    @IBAction func didConsolidatingCountsChanged(_ sender: Any) {
        SettingMgr.consolidatingCounts = switchConsolidatingCounts.isOn
    }
}
