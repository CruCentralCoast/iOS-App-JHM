//
//  RidesTableViewController.swift
//  Cru
//
//  Created by Max Crane on 1/28/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

class RidesTableViewController: UITableViewController {
    let roundTrip = "round-trip"
    let roundTripDirection = "both"
    let fromEvent = "from event"
    let toEvent = "to event"
    let driver = "driver"
    let rider = "rider"
    
    var rides = [Ride]()
    var events = [Event]()
    var tappedRide = Ride?()
    var tappedEvent = Event?()
    
    //TODO: Get gcm id associated with device and only populate rides associated with that id
    let myName = "Daniel Toy"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "FreightSans Pro", size: 20)!]
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)


        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        RideUtils.getRidesByGCMToken(Config.gcmId(), inserter: insertRide, afterFunc: finishRideInsert)
        ServerUtils.loadResources(.Event, inserter: insertEvent, afterFunc: finishInserting)
    }
    
    func refresh(sender:AnyObject)
    {
        rides.removeAll()
        self.tableView.reloadData()
        // Updating your data here...
        RideUtils.getRidesByGCMToken(Config.gcmId(), inserter: insertNewRide, afterFunc: finishRefresh)

        
    }
    
    func finishRideInsert(){
        rides.sortInPlace()
        self.tableView.reloadData()
    }
 
    
    
    func finishRefresh(){
        rides.sortInPlace()
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func insertNewRide(dict : NSDictionary){
        let newRide = Ride(dict: dict)
        rides.insert(newRide!, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    func insertRide(dict : NSDictionary) {
        //create ride
        let newRide = Ride(dict: dict)
        
        //insert into ride array
        rides.insert(newRide!, atIndex: 0)
        
        rides.sortInPlace()
        
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    
    func finishInserting(){
        self.tableView.beginUpdates()
        
        
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func insertEvent(dict : NSDictionary) {
        //create event
        let event = Event(dict: dict)
        
        //insert into event array
        events.insert(event!, atIndex: 0)
    }
    
    func getEventNameForEventId(id : String)->String{
        
        for event in events{
            if(event.id != "" && event.id == id){
                return event.name
            }
        }

        return "Max's Golf Lessons"
    }
    
    func getEventForEventId(id : String)->Event{
        
        for event in events{
            if(event.id != "" && event.id == id){
                return event
            }
        }
        
        return Event()!
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Rides"
        
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //load cell and ride associated with that cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ride", forIndexPath: indexPath) as! RideTableViewCell
        let ride = rides[indexPath.row]

        
        
        cell.day.text = String(ride.day)
        cell.month.text = ride.month
        
        
        //TODO: Change this to check against GCM id not driver name
        //if(ride.driverName == myName){
        if(ride.gcmId == Config.gcmId()){
            cell.rideType.text = driver
            cell.icon.image  = UIImage(named: driver)
        }
        else
        {
            cell.rideType.text = rider
            cell.icon.image = UIImage(named: rider)
        }
        
        
        
        cell.eventTitle.text = getEventNameForEventId(ride.eventId)
        
        return cell
    }

    @IBAction func addRideSelected(sender: AnyObject) {
        let newRideAlert = UIAlertController(title: "New Ride", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        newRideAlert.addAction(UIAlertAction(title: "Offer Ride", style: .Default, handler: handleOfferRide))
        newRideAlert.addAction(UIAlertAction(title: "Find a Ride", style: .Default, handler: handleFindRide))
        newRideAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(newRideAlert, animated: true, completion: nil)
    }
    
    func handleOfferRide(action: UIAlertAction){
        self.performSegueWithIdentifier("offerridesegue", sender: self)
        
    }
    
    func handleFindRide(action: UIAlertAction){
        self.performSegueWithIdentifier("findridesegue", sender: self)
    }
     
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tappedRide = rides[indexPath.row]
            tappedEvent = getEventForEventId((tappedRide?.eventId)!)
        
            if(tappedRide?.gcmId == Config.gcmId()){
                self.performSegueWithIdentifier("driverdetailsegue", sender: self)
            }
            else{
                self.performSegueWithIdentifier("riderdetailsegue", sender: self)
            }
        
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "riderdetailsegue") {
            
            let yourNextViewController = (segue.destinationViewController as! RiderRideDetailViewController)
            
            yourNextViewController.ride = tappedRide
            yourNextViewController.event = tappedEvent
        }
        
        if(segue.identifier == "driverdetailsegue") {
            
            let yourNextViewController = (segue.destinationViewController as! DriverRideDetailViewController)
            
            yourNextViewController.ride = tappedRide
            yourNextViewController.event = tappedEvent
            //yourNextViewController.passengers = tappedRide!.passengers
        }
        
    }
        
        

}

//    extension Array where Element: Equatable{
//        mutating func removeObject(object: Element){
//            if let index = self.indexOf(object){
//                self.removeAtIndex(index)
//            }
//        }
//    }

