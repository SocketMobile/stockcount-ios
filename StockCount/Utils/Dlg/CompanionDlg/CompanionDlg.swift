//
//  CompanionDlg.swift
//  StockCount
//
//  Created by IT Star on 1/17/18.
//  Copyright © 2018 Socket Mobile, Inc.
//
// Dialog that inform user either try connect scanner using Companion app or continue launch the system camera.

import Foundation
import UIKit

class CompanionDlg : UIView, Modal {
    
    var backgroundView : UIView {
        get {
            return _backgroundView
        }
    }
    var dialogView : UIView {
        get {
            return _dialogView
        }
        
        set {
            
        }
    }
    
    @IBOutlet weak var _backgroundView: UIView!
    @IBOutlet weak var _dialogView: UIView!
    @IBOutlet weak var btnUseCamera: UIButton!
    @IBOutlet weak var btnCompanion: UIButton!
    
    weak var delegate : CompanionDlgDelegate? = nil
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }
    
    func xibSetup() {
        let bundle = Bundle(for: type(of: self))
        
        let nibName = "CompanionDlg"
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(view)
        
        btnUseCamera.layer.borderColor = tintColor.cgColor
        btnCompanion.titleLabel?.textAlignment = .center
    }
    
    //MARK: - Events
    
    private func closeDlgWithAction(_ action : enumCompanionDlgCloseAction = .none) {
        dismiss(animated: true)
        delegate?.companionDlg(nil, closeAction: action)
    }
    
    @IBAction func onBtnClose(_ sender: Any) {
        closeDlgWithAction()
    }
    @IBAction func onBtnBG(_ sender: Any) {
        closeDlgWithAction()
    }
    @IBAction func onBtnOpenCompanion(_ sender: Any) {
        closeDlgWithAction(.openCompanionApp)
    }
    
    @IBAction func onBtnCamera(_ sender: Any) {
        closeDlgWithAction(.continueWithCamera)
    }

}
enum enumCompanionDlgCloseAction {
    case none
    case openCompanionApp
    case continueWithCamera
    
}

protocol CompanionDlgDelegate : class {
    func companionDlg(_ companionDlg : CompanionDlg?, closeAction : enumCompanionDlgCloseAction)
}

extension CompanionDlgDelegate {
    func companionDlg(_ companionDlg : CompanionDlg?, closeAction : enumCompanionDlgCloseAction) { }
}
