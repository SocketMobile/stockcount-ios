//
//  NibView.swift
//  InventoryUtility
//
//  Created by IT Star on 2/12/18.
//  Copyright © 2018 Socket Mobile Inc.
//

import Foundation
import UIKit

class NibView : UIView {
    var view : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //Setup view from .xib file
        xibSetup()
    }
}

private extension NibView {
    func xibSetup() {
        backgroundColor = UIColor.clear
        
        view = loadNib()
        //use bounds not frame or it'll be offset
        view.frame = bounds
        //Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView": view]))
        
    }
}
