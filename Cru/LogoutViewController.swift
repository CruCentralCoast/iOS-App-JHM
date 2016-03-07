

import UIKit

class LogoutViewController: UIViewController {


    @IBOutlet weak var loggedInLabel: UILabel!
    
    
    override func viewDidLoad() {
        loggedInLabel.text = "You are alredy logged in as " + GlobalUtils.loadString(Config.username)
    }
    
    
    
    @IBAction func logoutPressed(sender: AnyObject) {
        LoginUtils.logout()
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
    }
    
}
