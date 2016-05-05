//
//  DriverRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

class DriverRideDetailViewController: UIViewController, UITableViewDelegate {
    
    //MARK: Properties
    var event: Event!
    var ride: Ride!
    var passengers = [Passenger]()
    let cellHeight = CGFloat(60)
    var rideVC: RidesViewController?
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var passengerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var departureLoc: UITextView!
    @IBOutlet weak var rideName: UILabel!
    @IBOutlet weak var passengerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentViewHeight.constant = CGFloat(600)
        adjustPageConstraints()
        self.passengerTable.delegate = self
        passengerTable.scrollEnabled = false;
        rideName.text = event!.name
        CruClients.getRideUtils().getPassengersByIds(ride.passengers, inserter: insertPassenger, afterFunc: {success in
            //TODO: should be handling failure here
        })
        departureTime.text = ride.time
        //departureLoc.dataDetectorTypes = UIDataDetectorTypes.None
        //departureLoc.dataDetectorTypes = UIDataDetectorTypes.Address
        departureLoc.text = nil
        departureLoc.text = ride.getCompleteAddress()
        passengerTable.backgroundColor = UIColor.clearColor()
        
        var editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "goToEditPage")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    
    func goToEditPage(){
        self.performSegueWithIdentifier("editSegue", sender: self)
    }
    
    func insertPassenger(newPassenger: NSDictionary){
        let newPassenger = Passenger(dict: newPassenger)
        passengers.append(newPassenger)
        self.passengerTable.reloadData()
        adjustPageConstraints()
        
    }
    
    func adjustPageConstraints(){
        //we don't want to expand the table/view size unless there is more than 5 passengers
        //because the table can already hold 5 when the page loads
        if(self.passengers.count > 5){
            let tvHeight = (CGFloat(self.passengers.count) * self.cellHeight)
            var heightExpansion  = CGFloat(0)
            
            if(tvHeight > self.passengerTableHeight.constant){
                heightExpansion = tvHeight - self.passengerTableHeight.constant
            }
            
            let newHeight = self.view.frame.size.height + heightExpansion
            let newFrame = CGRectMake(0, 0, self.view.frame.size.width, newHeight)
            
            //set view frame, tableheight, and content view height
            self.view.frame = newFrame
            self.passengerTableHeight.constant = tvHeight
            self.contentViewHeight.constant = newHeight
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableView functions for the passenger list
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    //Set up the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PassengerTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PassengerTableViewCell
        
        cell.nameLabel!.text = passengers[indexPath.row].name
        cell.phoneLabel!.text = passengers[indexPath.row].phone
        
        if(ride.direction == "to event") {
            cell.tripIndicator!.image = UIImage(named: "toEvent")
        }
        else if(ride.direction == "from event") {
            cell.tripIndicator!.image = UIImage(named: "fromEvent")
        }
        else {
            cell.tripIndicator!.image = UIImage(named: "roundTrip")
        }
        
        
        if(indexPath.row % 4 == 0) {
            cell.nameLabel.textColor = CruColors.darkBlue
            cell.phoneLabel.textColor = CruColors.darkBlue
        }
        else if(indexPath.row % 4 == 1) {
            cell.nameLabel.textColor = CruColors.lightBlue
            cell.phoneLabel.textColor = CruColors.lightBlue
        }
        else if(indexPath.row % 4 == 2) {
            cell.nameLabel.textColor = CruColors.yellow
            cell.phoneLabel.textColor = CruColors.yellow
        }
        else if(indexPath.row % 4 == 3) {
            cell.nameLabel.textColor = CruColors.orange
            cell.phoneLabel.textColor = CruColors.orange
        }
        return cell
    }
    
    // Reload the data every time we come back to this view controller
    override func viewDidAppear(animated: Bool) {
        passengerTable.reloadData()
        self.navigationItem.title = "Ride Details"
    }
    
    // MARK: - Navigation
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
        
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        Cancler.confirmCancel(self, handler: cancelConfirmed)
    }
    
    func cancelConfirmed(action: UIAlertAction){
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        CruClients.getRideUtils().leaveRideDriver(ride.id, handler: handleCancelResult)
    }
    
    func handleCancelResult(success: Bool){
        if(success){
            Cancler.showCancelSuccess(self, handler: { action in
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                    self.rideVC?.refresh(self)
                }
                
            })
        }
        else{
            Cancler.showCancelFailure(self)
        }
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editSegue"{
            if let destVC = segue.destinationViewController as? EditRideViewController{
                print("this hapepned")
                destVC.ride = ride
                destVC.event = event
            }
            
        }
    }
    
}
