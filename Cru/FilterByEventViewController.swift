//
//  FilterByEventViewController.swift
//  Cru
//
//  Created by Max Crane on 2/17/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

class FilterByEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource /*UIPickerViewDelegate, UIPickerViewDataSource*/ {
    
    @IBOutlet weak var rideTable: UITableView!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    //var rides = ["ride1", "ride2"]
    var events = [Event]()
    var filteredRides = [Ride]()
    var allRides = [Ride]()
    
    //this is dumb we need to change this
    var tempEvent: Event?
    var selectedEvent: Event? {
        didSet {
            if let selectedEvent = selectedEvent {
                eventNameLabel.text = selectedEvent.name
                filterRidesByEventId(selectedEvent.id)
            }
        }
    }
    var selectedRide: Ride?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make pickerview and tableview recognize this class
        //as their delegate and data source
        rideTable.delegate = self
        rideTable.dataSource = self
        
        navigationItem.title = "Available Rides"
        
        if tempEvent == nil {
            loadRides(nil)
        }
    }
    
    func loadRides(event: Event?) {
        print("LOADING RIDES")
        print(event)
        tempEvent = event
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        RideUtils.getRidesNotDriving(Config.gcmId(), inserter: insertRide, afterFunc: loadRidesCompletionHandler)
    }
    
    private func insertRide(dict: NSDictionary) {
        allRides.append(Ride(dict: dict)!)
    }
    
    private func loadRidesCompletionHandler() {
        print("COMPLETE")
        if tempEvent != nil {
            selectedEvent = tempEvent
        }
        
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }
    
    private func filterRidesByEventId(eventId: String){
        filteredRides.removeAll()
        
        print("FILTERING")
        
        for ride in allRides {
            if(ride.eventId == eventId && ride.hasSeats()){
                filteredRides.append(ride)
            }
        }
        
        self.rideTable.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRides.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rideCell") as! OfferedRideTableViewCell
        
        let thisRide = filteredRides[indexPath.row]
        cell.month.text = thisRide.month
        cell.day.text = String(thisRide.day)
        cell.time.text = GlobalUtils.stringFromDate(thisRide.date!, format: "h:mma")
        
        cell.seatsLeft.text = thisRide.seatsLeft() + " seats left"
        
        if(thisRide.seatsLeft() == 1){
            cell.seatsLeft.textColor = UIColor(red: 0.729, green: 0, blue: 0.008, alpha: 1.0)
 
        }
        else if(thisRide.seatsLeft() == 2){
            cell.seatsLeft.textColor = UIColor(red: 0.976, green: 0.714, blue: 0.145, alpha: 1.0)
        }
        else{
            cell.seatsLeft.textColor = UIColor(red: 0, green:  0.427, blue: 0.118, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedRide = filteredRides[indexPath.row]
            
        performSegueWithIdentifier("joinSegue", sender: self)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // Function for sending the selected event to this view controller.
    // sets the selected event to the event that was selected in the event table view controller.
    func selectVal(event: Event){
        self.selectedEvent = event
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let vc = segue.destinationViewController as? JoinRideViewController where segue.identifier == "joinSegue" {
                    vc.ride = self.selectedRide
                    vc.event = self.selectedEvent
        }
        
        //check if we're going to event modal
        if segue.identifier == "pickEvent" {
            if let destinationVC = segue.destinationViewController as? EventModalViewController {
                destinationVC.eventModalClosure = { event in
                    self.selectedEvent = event
                }
            }
        }
    }
}
