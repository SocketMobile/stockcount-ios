//
//  CustomNavBarViewController.swift
//  StockCount
//
//  Created by Sohel Dhanani on 2/12/18.
//  Copyright © 2018 Socket Mobile Inc.
//

import Foundation
import UIKit

class CustomNavBarViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBarItems()
    }
    
    //MARK: - Customize Navigation Bar
    func initNavBarItems() {
        
    }
    
    func createBarButtonFromImage(_ named : String, target : Any?, action : Selector?) -> UIBarButtonItem? {
        guard let img = UIImage(named: named) else {return nil}
        
        let frameImg = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        let imgBtn = UIButton(frame: frameImg)
        imgBtn.setBackgroundImage(img, for: .normal)
        if let eventAction = action {
            imgBtn.addTarget(target, action: eventAction, for: .touchUpInside)
        }
        imgBtn.showsTouchWhenHighlighted = true
    
        return UIBarButtonItem(customView: imgBtn)
    }
    
}
