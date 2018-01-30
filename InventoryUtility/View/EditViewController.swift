import Foundation
import UIKit

class EditViewController: UIViewController, UITextViewDelegate
{
    lazy var editController = EditController(view: self)
    
    var fileName : String = ""
    
    var scanDlg : ScanDlg? = nil
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTopButtons(isDoneVisible: false)
        
        //Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        //Keyboard Toolbar
        let numberToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolBar.barStyle = UIBarStyle.default
        numberToolBar.items = [
            UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(onKeyboardScan)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(named: "btn_done"), style: .plain, target: self, action: nil),
            UIBarButtonItem(title: "Scan", style: .plain, target: self, action: #selector(onKeyboardScan))
        ]
        
        numberToolBar.sizeToFit()
        txtView.inputAccessoryView = numberToolBar
        
        editController.readFile(fileName)        
    }
    
    @objc func onKeyboardScan() {
        editController.triggerScan()
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
        editController.setSoftScan(false)
        navigationController?.popViewController(animated: true)
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
    
    @IBAction func onBtnShare(_ sender: Any) {
        editController.saveFile(fileName, strContent: txtView.text)
        if let fileURL = FileMgr.getURL(fileName: fileName) {
            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Setting & Done Buttons
    
    @IBOutlet weak var btnSettingTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var btnDoneTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var btnDone: UIButton!
    
    
    private func updateTopButtons(isDoneVisible : Bool) {
        
        btnDone.isHidden = !isDoneVisible
        
        btnSettingTrailing.constant = btnDoneTrailing.constant
        if (isDoneVisible) {
            btnSettingTrailing.constant = -btnDone.frame.width + 2 * btnDoneTrailing.constant
        }
    }
    
    @IBAction func onBtnDone(_ sender: Any) {
        self.view.endEditing(true)
        editController.saveFile(fileName, strContent: txtView.text)
        updateTopButtons(isDoneVisible: false)
    }
    
    @IBAction func onBtnSetting(_ sender: Any) {
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
        var curContent = txtView.text ?? ""
        curContent += strLine
        
        txtView.text = curContent
        setCursorToEnd()
        
        editController.saveFile(fileName, strContent: curContent)
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
    
}
//MARK: - CompanionDlg Delegate
extension EditViewController : CompanionDlgDelegate {
    func companionDlg(_ companionDlg: CompanionDlg?, closeAction: enumCompanionDlgCloseAction) {
        switch closeAction {
        case .continueWithCamera:
            editController.setSoftScan()
        default:
            txtView.becomeFirstResponder()
            break
        }
    }
}
