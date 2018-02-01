//
//  OptionViewController.swift
//  InventoryUtility
//
//  Created by IT Star on 01/20/18.
//  Copyright © 2018 Socket Mobile, Inc.
//

import Foundation
import UIKit

class OptionViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Back
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
