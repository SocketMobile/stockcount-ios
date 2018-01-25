//
//  SettingViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 1/18/18.
//  Copyright © 2018 Simple Design Inc. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchAutoQuantity.isOn = SettingMgr.autoAddQuantity
        showQuantityFormat(SettingMgr.delineatorComma)
        showNewLineFormat(SettingMgr.newLineForNewScan)
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Automatically Add Quantity
    
    @IBOutlet weak var switchAutoQuantity: UISwitch!
    
    @IBAction func didAutoQuantityChanged(_ sender: Any) {
        SettingMgr.autoAddQuantity = switchAutoQuantity.isOn
        
        updateTxtPreview()
    }
    
    //MARK: - Quantity format options
    
    @IBOutlet weak var imgCheckQuantityComma: UIImageView!
    @IBOutlet weak var imgCheckQuantityNoComma: UIImageView!
    
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
    
    
    //Mark: - New Line
    
    @IBOutlet weak var imgCheckNewLine: UIImageView!
    @IBOutlet weak var imgCheckNoNewLine: UIImageView!
    
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
    @IBOutlet weak var txtPreview: UITextView!
    func updateTxtPreview() {
        var strPreview = "The result will look like:\n"
        
        strPreview = strPreview + SettingMgr.getLineForBarcode()
        strPreview = strPreview + SettingMgr.getLineForBarcode()
        
        txtPreview.text = strPreview
        
        
    }
}
