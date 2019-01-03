//
//  OptionViewController.swift
//  StockCount
//
//  Created by Sohel Dhanani on 01/20/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit
import SKTCapture

class OptionViewController : UIViewController {
    
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var txtLink: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let versionString = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        lblVersion.text = "version".localized + versionString + "\nCapture [ver]"
        CaptureHelper.sharedInstance.getVersionWithCompletionHandler { (result, version) in
            DispatchQueue.main.async {
                let majorVersionString = String(version?.major ?? 0)
                let middleVersionString = String(version?.middle ?? 0)
                let minorVersionString = String(version?.minor ?? 0)
                let captureVersion = majorVersionString + "." + middleVersionString + "." + minorVersionString
                self.lblVersion.text = "version".localized + versionString + "\nCapture [\(captureVersion)]"
            }
        }
        let sdkString = "mobile_sdk".localized + "capture_sdk".localized
        let myAttribute = [ NSAttributedStringKey.font: UIFont(name: "System Font Regular", size: 15.0)! ]
        
        let attributedString = NSMutableAttributedString(string: sdkString, attributes: myAttribute)

        let linkStrLength = "capture_sdk".localized.count
        
        let range = NSMakeRange(attributedString.length - linkStrLength, linkStrLength)
        attributedString.addAttributes([.link : URL(string: "https://github.com/SocketMobile")!], range: range)
        
        txtLink.attributedText = attributedString
        txtLink.textAlignment = NSTextAlignment.center
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
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
