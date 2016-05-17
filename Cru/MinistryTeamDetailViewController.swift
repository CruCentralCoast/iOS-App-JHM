//
//  MinistryTeamDetailViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 4/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class MinistryTeamDetailViewController: UIViewController {

    @IBOutlet weak var ministryTeamNameLabel: UILabel!
    @IBOutlet weak var ministryTeamImage: UIImageView!
    @IBOutlet weak var ministryTeamDescription: UITextView!
    
    //storage manager
    var teamStorageManager: MapLocalStorageManager!
    
    //ministry team reference
    var ministryTeam: NSDictionary!
    
    //reference to previous vc
    var listVC: MinistryTeamViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ministryTeamNameLabel.text = ministryTeam["name"] as? String
        ministryTeamImage.load(ministryTeam["imageUrl"] as! String)
        
            ministryTeamDescription.text = ministryTeam["description"] as! String
    
        teamStorageManager = MapLocalStorageManager(key: Config.ministryTeamStorageKey)
    }
    
    //leaves the ministry team
    @IBAction func leaveMinistryTeam(sender: AnyObject) {
        let alert = UIAlertController(title: "Leaving Ministry Team", message: "Are you sure you would like to leave this Ministry Team?", preferredStyle: UIAlertControllerStyle.Alert)
        
        //add alert box actions
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Destructive, handler: unwindToMinistryTeamList))
        
        //present the alert box
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func unwindToMinistryTeamList(action: UIAlertAction){
        teamStorageManager.removeElement(ministryTeam["id"] as! String)
        
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
            
            if (listVC != nil){
                listVC?.refresh(self)
            }
            
        }
    }
}
