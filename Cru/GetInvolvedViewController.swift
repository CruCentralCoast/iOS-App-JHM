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

    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    @IBAction func goToCommunityGroup(sender: UIButton) {
        var view: UIViewController
        
        if let user = loadUserInfo() {
            view = self.storyboard!.instantiateViewControllerWithIdentifier("communityGroupsLoadedView")
        }
        else {
            view = self.storyboard!.instantiateViewControllerWithIdentifier("communityGroupsUnloadedView")
        }
        
        self.showViewController(view, sender: self)
    }
    
    //function for loading the user's information if it exists
    func loadUserInfo() -> User? {
        let defaults = NSUserDefaults()
        
        if let user = defaults.objectForKey("user") {
            return user as? User
        }
        else {
            return nil
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
