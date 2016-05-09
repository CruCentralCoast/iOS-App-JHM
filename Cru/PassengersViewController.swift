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
        cell?.phoneLabel.text = passengers[indexPath.row].phone
        return cell!
    }
    @IBAction func okPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
