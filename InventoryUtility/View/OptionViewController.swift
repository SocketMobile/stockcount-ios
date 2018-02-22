//
//  OptionViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 01/20/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit

class OptionViewController : UIViewController {
    
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var txtLink: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let versionString = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        lblVersion.text = "version".localized + versionString
        
        let attributedString = NSMutableAttributedString(attributedString: txtLink.attributedText)
        
        let range = NSMakeRange(attributedString.length - 5, 4)
        attributedString.addAttributes([.link : URL(string: "https://github.com/SocketMobile/inventory-ios")], range: range)
        
        txtLink.attributedText = attributedString
        txtLink.delegate = self
    }
    
    @IBAction func onBtnGetStarted(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Instruction", bundle: nil)
        let viewController = storyBoard.instantiateInitialViewController()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
    }
    
}

extension OptionViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
