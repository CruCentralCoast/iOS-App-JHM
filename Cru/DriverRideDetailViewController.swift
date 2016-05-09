//
//  DriverRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

class DriverRideDetailViewController: UIViewController, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
    
    //MARK: Properties
    var details = [EditableItem]()
    var event: Event!
    var ride: Ride!{
        didSet {
            
        }
    }
    var passengers = [Passenger]()
    let cellHeight = CGFloat(60)
    var rideVC: RidesViewController?
    @IBOutlet weak var passengerTable: UITableView!
    @IBOutlet weak var detailsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        details.append(EditableItem(itemName: "Event:", itemValue: event!.name, itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: "Departure Time:", itemValue: ride.getTime(), itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: "Departure Date:", itemValue: ride.getDate(), itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: "Departure Address:", itemValue: ride.getCompleteAddress(), itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: "Direction:", itemValue: ride.getDirection(), itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: "Seats:", itemValue: String(ride.seats), itemEditable: false, itemIsText: true))
        
        
        
        //self.contentViewHeight.constant = CGFloat(600)
        //adjustPageConstraints()
        
        //self.passengerTable.delegate = self
        
        //passengerTable.scrollEnabled = false;
        //rideName.text = event!.name
        CruClients.getRideUtils().getPassengersByIds(ride.passengers, inserter: insertPassenger, afterFunc: {success in
            //TODO: should be handling failure here
        })
        //departureTime.text = ride.getTime()
        //departureDate.text = ride.getDate()
        
        //departureLoc.dataDetectorTypes = UIDataDetectorTypes.None
        //departureLoc.dataDetectorTypes = UIDataDetectorTypes.Address
        
        //departureLoc.text = nil
        //departureLoc.text = ride.getCompleteAddress()
        
        //passengerTable.backgroundColor = UIColor.clearColor()
        
        var editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "goToEditPage")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    
    func goToEditPage(){
        self.performSegueWithIdentifier("editSegue", sender: self)
    }
    
    func insertPassenger(newPassenger: NSDictionary){
        let newPassenger = Passenger(dict: newPassenger)
        passengers.append(newPassenger)
        //self.passengerTable.reloadData()
        //adjustPageConstraints()
        
    }
    
    func adjustPageConstraints(){
        //we don't want to expand the table/view size unless there is more than 5 passengers
        //because the table can already hold 5 when the page loads
//        if(self.passengers.count > 5){
//            let tvHeight = (CGFloat(self.passengers.count) * self.cellHeight)
//            var heightExpansion  = CGFloat(0)
//            
//            if(tvHeight > self.passengerTableHeight.constant){
//                heightExpansion = tvHeight - self.passengerTableHeight.constant
//            }
//            
//            let newHeight = self.view.frame.size.height + heightExpansion
//            let newFrame = CGRectMake(0, 0, self.view.frame.size.width, newHeight)
//            
//            //set view frame, tableheight, and content view height
//            self.view.frame = newFrame
//            self.passengerTableHeight.constant = tvHeight
//            self.contentViewHeight.constant = newHeight
//        }
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
        
        if (tableView.isEqual(passengerTable)){
            return passengers.count
        }
        
        if (tableView.isEqual(detailsTable)){
            return details.count
        }
        
        
        return 0
    }
    //Set up the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var chosenCell: UITableViewCell?
        
        if(tableView.isEqual(passengerTable)){
            let cellIdentifier = "passengerCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PassengerTableViewCell
            
            cell.nameLabel!.text = passengers[indexPath.row].name
            cell.phoneLabel!.text = passengers[indexPath.row].phone
            
            if(ride.direction == "to event") {
                //cell.tripIndicator!.image = UIImage(named: "toEvent")
            }
            else if(ride.direction == "from event") {
                //cell.tripIndicator!.image = UIImage(named: "fromEvent")
            }
            else {
                //cell.tripIndicator!.image = UIImage(named: "roundTrip")
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
            chosenCell = cell
        }
        
        if(tableView.isEqual(detailsTable)){
            let cellIdentifier = "detailCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DetailCell
            cell.title.text = details[indexPath.row].itemName
            cell.value.text = details[indexPath.row].itemValue
            //cell.contentValue.text = details[indexPath.row].itemValue
            //cell.contentTextField.text = details[indexPath.row].itemValue
            chosenCell = cell
        }
        
        return chosenCell!
        
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView.isEqual(passengerTable)){
            return CGFloat(50.0)
        }
        
        if(tableView.isEqual(detailsTable)){
            return CGFloat(60.0)
        }
        
        return CGFloat(44.0)
    }
    
    // Reload the data every time we come back to this view controller
    override func viewDidAppear(animated: Bool) {
        //passengerTable.reloadData()
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
                destVC.ridesVC = self.rideVC
                destVC.rideDetailVC = self
            }
            
        }
        else if(segue.identifier == "passengerSegue"){
            let popoverVC = segue.destinationViewController
            
            let controller = popoverVC.popoverPresentationController
            
            if(controller != nil){
                controller?.delegate = self
            }
            
            
            if let vc = popoverVC as? PassengersViewController{
                vc.passengers = self.passengers
                print("there are \(self.passengers.count) passengers")
            }
        }
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
