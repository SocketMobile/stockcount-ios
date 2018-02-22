//
//  ScanDlg.swift
//  StockCount
//
//  Created by IT Star on 1/17/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit

class ScanDlg : UIView, Modal {
    
    
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

    
    @IBOutlet var _backgroundView: UIView!
    @IBOutlet weak var _dialogView: UIView!
    
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
        
        let nibName = "ScanDlg"
        
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        addSubview(view)
    }
}
