//
//  RidesViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 4/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class RidesViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleOfferRide(sender: AnyObject){
        self.performSegueWithIdentifier("offerridesegue", sender: self)
        
    }
    
    @IBAction func handleFindRide(sender: AnyObject){
        self.performSegueWithIdentifier("findridesegue", sender: self)
    }
}
