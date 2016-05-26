//
//  GetInvolvedViewController.swift
//  Cru
//
//  Created by Max Crane on 11/17/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class GetInvolvedViewController: UIViewController, UITabBarDelegate, SWRevealViewControllerDelegate {
    //MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //container views for each section
    @IBOutlet weak var communityGroupContainer: UIView!
    @IBOutlet weak var ministryTeamContainer: UIView!
    @IBOutlet weak var inCommunityGroupContainer: UIView!

    //selector bar
    @IBOutlet weak var selectorBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //side menu reveal controller
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().delegate = self
        }
                selectorBar.selectedItem = selectorBar.items![0]
        selectorBar.tintColor = UIColor.whiteColor()

        //Set the nav title & font
        navigationItem.title = "Get Involved"
        
        self.navigationController!.navigationBar.titleTextAttributes  = [ NSFontAttributeName: UIFont(name: Config.fontBold, size: 20)!, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
    }
    
    override func viewWillAppear(animated: Bool) {
        showCGContainer()
    }
    
    //tab bar function 
    //TODO figure out how to call this in viewDidLoad
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        switch (item.title!){
        case "Community Groups":
            showCGContainer()
        case "Ministry Teams":
            ministryTeamContainer.hidden = false
            communityGroupContainer.hidden = true
            inCommunityGroupContainer.hidden = true
        default :
            showCGContainer()
        }
    }
    
    private func showCGContainer() {
        if (GlobalUtils.loadString(Config.communityGroupKey) == "") {
            communityGroupContainer.hidden = false
            ministryTeamContainer.hidden = true
            inCommunityGroupContainer.hidden = true
        } else {
            ministryTeamContainer.hidden = true
            communityGroupContainer.hidden = true
            inCommunityGroupContainer.hidden = false
        }
    }
    
    //reveal controller function for disabling the current view
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        
        if position == FrontViewPosition.Left {
            for view in self.view.subviews {
                view.userInteractionEnabled = true
            }
        }
        else if position == FrontViewPosition.Right {
            for view in self.view.subviews {
                view.userInteractionEnabled = false
            }
        }
    }
}
