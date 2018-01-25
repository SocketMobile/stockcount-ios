
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
