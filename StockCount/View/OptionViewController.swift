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
        let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "System Font Regular", size: 15.0)! ]
        
        let attributedString = NSMutableAttributedString(string: sdkString, attributes: myAttribute)

        let linkStrLength = "capture_sdk".localized.count
        
        let range = NSMakeRange(attributedString.length - linkStrLength, linkStrLength)
        attributedString.addAttributes([.link : URL(string: "https://github.com/SocketMobile")!], range: range)
        
        txtLink.attributedText = attributedString
        txtLink.textAlignment = NSTextAlignment.center
        txtLink.delegate = self
        
        loadingIndicator.isHidden = true
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
        let regionCode = Locale.current.regionCode
        
        //for the CN link, we don't have Socket Store suitable for China. We are using the Amazon link.
        if regionCode == "CN" {
            UIApplication.shared.open(URL(string: ChinaLink)!, options: [:], completionHandler: nil)
            return
        }
        
        let refersionKey = getRefersionKeys(regionCode!)
        let parameters: Parameters = [
            "refersion_public_key": refersionKey.pub_key,
            "refersion_secret_key": refersionKey.sec_key,
            "affiliate_code": refersionKey.aff_code
        ]
        let url = "https://www.refersion.com/api/get_affiliate"
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (resp) in
            self.loadingIndicator.isHidden = true
            self.loadingIndicator.stopAnimating()
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
                    let alertController = UIAlertController(title: "error".localized, message: "JSON Parse Error".localized, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "ok".localized, style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    return
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
