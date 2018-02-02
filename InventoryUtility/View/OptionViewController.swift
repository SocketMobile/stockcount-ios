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
    
    
    @IBOutlet weak var lblVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let versionString = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? ""
        
        lblVersion.text = "version".localized + versionString
    }
    
    //MARK: - Back
    
    @IBAction func onBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
