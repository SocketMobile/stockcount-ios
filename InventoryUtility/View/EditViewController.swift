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
    var fileName : String = ""
    
    /*var btnSetting: UIBarButtonItem!
    var btnDone: UIBarButtonItem!*/
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*btnSetting = UIBarButtonItem(title: "Setting", style: .plain, target: self, action:#selector(onBtnSetting))
//        btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onBtnDone))
//        navigationItem.rightBarButtonItems = [btnDone, btnSetting]
        navigationItem.rightBarButtonItems = [btnSetting]*/
        updateTopButtons(isDoneVisible: false)
        
        //Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //Read File Content
        let strContent = FileMgr.readFile(fileName: fileName)
        txtView.text = strContent
        
        //Set Cursor to end text
        let curPosition = txtView.endOfDocument
        txtView.selectedTextRange = txtView.textRange(from: curPosition, to: curPosition)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        txtView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Back
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    /*@objc func onBtnSetting() {
        btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onBtnDone))
        navigationItem.rightBarButtonItems = [btnDone, btnSetting]
    }
    
    @objc func onBtnDone() {
        self.view.endEditing(true)
        navigationItem.rightBarButtonItems = [btnSetting]
        
        FileMgr.saveFile(fileName: fileName, content: txtView.text)
    }*/
    
    //MARK: - TextField Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        /*btnDone = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(onBtnDone))
        navigationItem.rightBarButtonItems = [btnDone, btnSetting]*/
        updateTopButtons(isDoneVisible: true)
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

    //MARK: - Delete & Share
    
    @IBAction func onBtnRemove(_ sender: Any) {
        FileMgr.deleteFile(fileName: fileName)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onBtnShare(_ sender: Any) {
        if let fileURL = FileMgr.getURL(fileName: fileName) {
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Setting & Done Buttons
    
    @IBOutlet weak var btnSettingTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var btnDoneTrailing: NSLayoutConstraint!
    
    func updateTopButtons(isDoneVisible : Bool) {
        btnSettingTrailing.constant = isDoneVisible ? -46 : -8
        btnDoneTrailing.constant = isDoneVisible ? -8 : 38
    }
    
    @IBAction func onBtnDone(_ sender: Any) {
        self.view.endEditing(true)
        FileMgr.saveFile(fileName: fileName, content: txtView.text)
        updateTopButtons(isDoneVisible: false)
    }
    
    @IBAction func onBtnSetting(_ sender: Any) {
        updateTopButtons(isDoneVisible: false)
    }
    
    
    
    
}
