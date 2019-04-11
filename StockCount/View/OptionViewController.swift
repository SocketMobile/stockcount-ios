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
import Alamofire
import SwiftyJSON

class OptionViewController : UIViewController {
    
    
    @IBOutlet weak var lblVersion: UILabel!
    @IBOutlet weak var txtLink: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CaptureHelper.sharedInstance.dispatchQueue = DispatchQueue.main
        let appVer = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        updateVersion(appVer, "fetching".localized)
        CaptureHelper.sharedInstance.getVersionWithCompletionHandler { (result, version) in
            var captureVersion = "error".localized
            if version != nil && result == SKTResult.E_NOERROR {
                captureVersion = "\(version!.major).\(version!.middle).\(version!.minor)"
            }
            self.updateVersion(appVer, captureVersion)
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
    
    func updateVersion(_ appVer: String, _ captureVer: String) {
        lblVersion.text = "\("version".localized)\(appVer)\n\("Capture".localized) \(captureVer)"
    }
    @IBAction func onBuyScannerClicked(_ sender: Any) {
        let pub_key = "pub_9a42760dc57269d2f616"
        let sec_key = "sec_86be30771c1af32a57df"
        let aff_code = "7daad6"
        
        let parameters: Parameters = [
            "refersion_public_key": pub_key,
            "refersion_secret_key": sec_key,
            "affiliate_code": aff_code
        ]
        
        let url = "https://www.refersion.com/api/get_affiliate"
        loadingIndicator.isHidden = false
        
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (resp) in
            self.loadingIndicator.isHidden = true
            if let _ = resp.error {
                let alertController = UIAlertController(title: "error".localized, message: resp.error?.localizedDescription ?? "", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if let json = resp.data {
                do {
                    let data = try JSON(data: json)
                    if let link = data["link"].string {
                        UIApplication.shared.open(URL(string: link)!, options: [:], completionHandler: nil)
                    }
                } catch {
                    
                }
            }
        }
    }
}

extension OptionViewController : UITextViewDelegate {
    @available(iOS 10.0, *)
    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
