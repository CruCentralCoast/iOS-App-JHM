//
//  PassengersViewController.swift
//  Cru
//
//  Created by Max Crane on 5/8/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class PassengersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var passengers = [Passenger]()
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? PassengerTableViewCell
        cell?.nameLabel.text = passengers[indexPath.row].name
        cell?.phoneLabel.text = PhoneFormatter.unparsePhoneNumber(passengers[indexPath.row].phone)
        
        
        let mod = indexPath.row % 4
        var color: UIColor?
        
        
        if(mod == 0) {
            color = CruColors.darkBlue
        }
        else if(mod == 1) {
            color = CruColors.lightBlue
        }
        else if(mod == 2) {
            color = CruColors.yellow
        }
        else if(mod == 3) {
            color = CruColors.orange
        }
        
        cell?.nameLabel.textColor = color
        cell?.phoneLabel.tintColor = color
        
        
        return cell!
    }
    @IBAction func okPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
