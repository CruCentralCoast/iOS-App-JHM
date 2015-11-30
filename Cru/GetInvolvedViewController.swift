//
//  GetInvolvedViewController.swift
//  Cru
//
//  Created by Max Crane on 11/17/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class GetInvolvedViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    struct Constants {
        static let userKey = "user"
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()

        if(self.revealViewController() != nil){
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Actions
    
    
    //function for saving a user's information if they are inputting it for the first time
    func saveUserInfo() {
        let defaults = NSUserDefaults()
        
        defaults.setObject(user, forKey: Constants.userKey)
    }
    
    //function for loading the user's information if it exists
    func loadUserInfo() {
        let defaults = NSUserDefaults()
        
        if let user = defaults.objectForKey(Constants.userKey) {
            print(user)
        }
        else {
            print("No User data stored")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
