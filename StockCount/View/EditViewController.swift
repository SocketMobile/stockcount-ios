//
//  EditViewController.swift
//  StockCount
//
//  Created by Sohel Dhanani on 12/24/17.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit
import AudioToolbox

class EditViewController: CustomNavBarViewController, UITextViewDelegate
{
    lazy var editController = EditController(view: self)
    
    var fileName : String = ""
    
    var scanDlg : ScanDlg? = nil
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtView: UITextView!
    
    var keyboardToolBar : KeyboardToolBar?
    private let appleKeyboardIdentifier = ["en_US@hw=Automatic;sw=QWERTY", "en_US@sw=QWERTY;hw=Automatic"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTopButtons(isDoneVisible: false)
        
        //Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardInputModeChanged), name: NSNotification.Name.UITextInputCurrentInputModeDidChange, object: nil)
        
        keyboardToolBar = KeyboardToolBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        keyboardToolBar?.delegate = self
        txtView.inputAccessoryView = keyboardToolBar
        
        editController.readFile(fileName)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtView.becomeFirstResponder()
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        editController.viewer = nil
        editController.isSoftScan = false
    }
    
    //MARK: - TextField Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
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
                self.keyboardHeightLayoutConstraint?.constant = 0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
                keyboardInputModeChanged()
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @objc func keyboardInputModeChanged() {
        print("Keyboard Identifier : \(UITextInputMode.activeInputModes[0].value(forKey: "identifier") as? String)")
        if let currentKeyboardId = UITextInputMode.activeInputModes[0].value(forKey: "identifier") as? String, appleKeyboardIdentifier.contains(currentKeyboardId) {
            keyboardToolBar?.setTypeUpdateEnabled(true)
        } else {
            keyboardToolBar?.setTypeUpdateEnabled(false)
        }
    }

    
    
    //MARK: - NavigationBar
    private func updateTopButtons(isDoneVisible : Bool) {
        var barButtonGroup : [UIBarButtonItem] = []
        if isDoneVisible {
            if let btnDone = createBarButtonFromImage("NavBar_Done", target: self, action: #selector(self.onBtnDone)) {
                barButtonGroup.append(btnDone)
            }
        }
        if let btnShare = createBarButtonFromImage("NavBar_Upload", target: self, action: #selector(self.onBtnShare)) {
            barButtonGroup.append(btnShare)
        }
        if let btnDelete = createBarButtonFromImage("NavBar_Delete", target: self, action: #selector(self.onBtnDelete)) {
            barButtonGroup.append(btnDelete)
        }
        
        self.navigationItem.rightBarButtonItems = barButtonGroup
    }
    
    @objc func onBtnDelete() {
        let alertController = UIAlertController(title: "confirmation".localized, message: "removeFile".localized + "\'\(fileName)\'", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default ) {(_) in
            self.editController.removeFile(self.fileName)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @objc func onBtnShare() {
        editController.saveFile(fileName, strContent: txtView.text)
        if let fileURL = FileMgr.getURL(fileName: fileName) {
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    @objc func onBtnDone() {
        self.view.endEditing(true)
        editController.saveFile(fileName, strContent: txtView.text)
        updateTopButtons(isDoneVisible: false)
    }
}
//MARK: - EditView View Protocol
protocol EditViewProtocol : class{
    func showFileContent(strContent : String?)
    
    func addScanData(strLine : String)
    
    func showScangDlg()
    func closeScanDlg()
    
    func showCompanionDlg()
    
    func getOverlayContextForSoftScan () -> UIViewController
    func showAlert(_ msg : String)
    
    func notifyScannerConnected(isConnected : Bool)
}
extension EditViewController : EditViewProtocol {
    private func setCursorToEnd() {
        let curPosition = txtView.endOfDocument
        txtView.selectedTextRange = txtView.textRange(from: curPosition, to: curPosition)
    }
    func showFileContent(strContent: String?) {
        txtView.text = strContent
        setCursorToEnd()
    }
    func addScanData(strLine: String) {
        if let selectedRange = txtView.selectedTextRange {
            if selectedRange.start == selectedRange.end {
                txtView.replace(selectedRange, withText: strLine)
            }
        } else {
            var curContent = txtView.text ?? ""
            curContent += strLine
            
            txtView.text = curContent
            setCursorToEnd()
        }
        
        if SettingMgr.vibrationOnScan {
            DispatchQueue.main.async {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
        
        editController.saveFile(fileName, strContent: txtView.text)
    }
    
    func showScangDlg() {
        self.view.endEditing(true)
        
        scanDlg = ScanDlg()
        scanDlg?.show(animated: true)
        
    }
    func closeScanDlg() {
        scanDlg?.dismiss(animated: true)
        txtView.becomeFirstResponder()
    }
    
    func showCompanionDlg() {
        self.view.endEditing(true)
        
        let companionDlg = CompanionDlg()
        companionDlg.delegate = self
        companionDlg.show(animated: true)
    }
    
    func getOverlayContextForSoftScan() -> UIViewController {
        return self
    }
    func showAlert(_ msg : String) {
        let alertController = UIAlertController(title: "alert".localized, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func notifyScannerConnected(isConnected : Bool) {
        keyboardToolBar?.updateConnection(isConnected: isConnected)
    }
    
}
//MARK: - CompanionDlg Delegate
extension EditViewController : CompanionDlgDelegate {
    func companionDlg(_ companionDlg: CompanionDlg?, closeAction: enumCompanionDlgCloseAction) {
        switch closeAction {
        case .continueWithCamera:
            editController.isSoftScan = true
        case .openCompanionApp:
            if let companionURL = URL(string: "https://itunes.apple.com/us/app/socket-mobile-companion/id1175638950") {
                UIApplication.shared.open(companionURL, options: [:], completionHandler: nil)
            }
        default:
            txtView.becomeFirstResponder()
            break
        }
    }
}

//MARK: - KeyboardToolBar
extension EditViewController : KeyboardToolBarDelegate {
    func didTriggerScan() {
        editController.triggerScan()
    }
    func didSwitchKeyboard() {
        let destType = txtView.keyboardType == .decimalPad ? UIKeyboardType.alphabet : UIKeyboardType.decimalPad
        updateKeyboardType(destType)
    }
    
    private func updateKeyboardType(_ destType : UIKeyboardType) {
        txtView.keyboardType = destType
        txtView.reloadInputViews()
        
        if txtView.isFirstResponder {
            txtView.resignFirstResponder()
            txtView.becomeFirstResponder()
        }
        
        let keyTitle = txtView.keyboardType == .decimalPad ? "key_alphabet".localized : "key_decimal".localized
        keyboardToolBar?.setKeyboardTitle(keyTitle)
    }
}
