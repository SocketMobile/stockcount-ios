//
//  SettingViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 1/18/18.
//  Copyright © 2018 Simple Design Inc. All rights reserved.
//

import Foundation
import UIKit

class SettingViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Automatically Add Quantity
    
    @IBOutlet weak var switchAutoQuantity: UISwitch!
    
    @IBAction func didAutoQuantityChanged(_ sender: Any) {
        
    }
    
}
