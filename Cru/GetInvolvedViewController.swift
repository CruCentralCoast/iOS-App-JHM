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

    @IBOutlet weak var communityGroupLabel: UILabel!
    @IBOutlet weak var communityGroupTextArea: UITextView!
    @IBOutlet weak var ministryTeamLabel: UILabel!
    @IBOutlet weak var ministryTeamTextArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        //iphone 4s and below models
        if (screenSize.height <= 480.0) {
            //make sure label fonts arent nil
            if let mtFont = ministryTeamLabel.font {
                ministryTeamLabel.font = UIFont(name: mtFont.fontName, size: 20)
            }
            if let cgFont = communityGroupLabel.font {
                communityGroupLabel.font = UIFont(name: cgFont.fontName, size: 20)
            }
            
            //make sure fonts arent nil to prevent crashing
            if let mtFont = ministryTeamTextArea.font {
                ministryTeamTextArea.font = UIFont(name: mtFont.fontName, size: 12)
            }
            if let cgFont = communityGroupTextArea.font {
                communityGroupTextArea.font = UIFont(name: cgFont.fontName, size: 12)
            }
        }
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
        
        if let _ = loadUserInfo() {
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
