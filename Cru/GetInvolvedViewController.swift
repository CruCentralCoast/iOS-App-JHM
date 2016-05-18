//
//  GetInvolvedViewController.swift
//  Cru
//
//  Created by Max Crane on 11/17/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class GetInvolvedViewController: UIViewController, UITabBarDelegate {
    //MARK: Properties
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //container views for each section
    @IBOutlet weak var communityGroupContainer: UIView!
    @IBOutlet weak var ministryTeamContainer: UIView!
    
    
    //selector bar
    @IBOutlet weak var selectorBar: UITabBar!
    
//    var communityGroupStorageManager: MapLocalStorageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //side menu reveal controller
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        selectorBar.selectedItem = selectorBar.items![0]
        selectorBar.tintColor = UIColor.whiteColor()
        
      
    }
    
    //tab bar function 
    //TODO figure out how to call this in viewDidLoad
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        switch (item.title!){
        case "Community Groups":
            communityGroupContainer.hidden = false
            ministryTeamContainer.hidden = true
        case "Ministry Teams":
            ministryTeamContainer.hidden = false
            communityGroupContainer.hidden = true
        default :
            communityGroupContainer.hidden = false
            ministryTeamContainer.hidden = true
        }
    }
}
