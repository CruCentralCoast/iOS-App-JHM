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
    }
    
    @IBAction func onClickMinistryView(recognizer: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "ministryteam", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("MinistryTeamsCollectionViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func onClickCommunityGroupView(recognizer: UITapGestureRecognizer) {
        print("HELLO")
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
}
