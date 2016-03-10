//
//  OfferRideViewController.swift
//  Cru
//
//  Superclass for creating a ride. This class handles all things related to general design that is shared among all ride creation pages (Offering a Ride / Receiving a Ride)
//
//  Created by Max Crane on 1/28/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class CreateRideViewController: UITableViewController {
    // Variable for holding whether or not somethingin the form has been edited
    var formHasBeenEdited = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let newBackButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "handleCancelRide:")
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    /* Function for handling canceling a submission of offering a ride. Displays an alert box if there is unsaved data in the offer ride form and asks the user if they would really like to exit */
    func handleCancelRide(sender: UIBarButtonItem) {
        if (formHasBeenEdited) {
            let cancelRideAlert = UIAlertController(title: "Cancel Ride", message: "Are you sure you would like to continue? All unsaved data will be lost!", preferredStyle: UIAlertControllerStyle.Alert)
            
            cancelRideAlert.addAction(UIAlertAction(title: "Yes", style: .Destructive, handler: performBackAction))
            cancelRideAlert.addAction(UIAlertAction(title: "No", style: .Cancel, handler: nil))
            presentViewController(cancelRideAlert, animated: true, completion: nil)
        }
        else {
            performBackAction(UIAlertAction())
        }
    }
    
    // Helper function for popping the offer rides view controller from the view stack and show the rides table
    func performBackAction(action: UIAlertAction) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
