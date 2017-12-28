//
//  EditViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 12/24/17.
//  Copyright © 2017 Simple Design Inc. All rights reserved.
//

import Foundation
import UIKit

class EditViewController: UIViewController, UITextViewDelegate
{
    
    var btnSetting: UIBarButtonItem!
    var btnDone: UIBarButtonItem!
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSetting = UIBarButtonItem(title: "Setting", style: .plain, target: self, action:#selector(onBtnSetting))
        btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onBtnDone))
        
        navigationItem.rightBarButtonItems = [btnDone, btnSetting]
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func onBtnSetting() {
        btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onBtnDone))
        navigationItem.rightBarButtonItems = [btnDone, btnSetting]
    }
    
    @objc func onBtnDone() {
        self.view.endEditing(true)
        navigationItem.rightBarButtonItems = [btnSetting]
    }
    
    //MARK: - TextField Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onBtnDone))
        navigationItem.rightBarButtonItems = [btnDone, btnSetting]
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 60
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
