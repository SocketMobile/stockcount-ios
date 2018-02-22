//
//  UIView.swift
//  StockCount
//
//  Created by Sohel Dhanani on 2/12/18.
//  Copyright © 2018 Socket Mobile Inc.
//

import Foundation
import UIKit

extension UIView {
    /** Loads instance from nib witht he same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

@IBDesignable extension UIView {
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        
        get {
            return layer.cornerRadius
        }
    }
}
