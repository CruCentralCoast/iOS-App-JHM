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
    var gcmId = "1234567"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "FreightSans Pro", size: 20)!]
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as! [String : AnyObject]
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)

        gcmId = SubscriptionManager.loadGCMToken()
        gcmId = "kH-biM4oppg:APA91bF1PlmRURQSi1UWB49ZRUIB0G2vfsyHcAqqOxX5WG5RdsZQnezCyPT4GPbJ9yQPYxDFTVMGpHbygnrEf9UrcEZITCfE6MCLQJwAr7p0sRklVp8vwjZAjvVSOdEIkLPydiJ_twtL"
        gcmId = "1234567"
        //ServerUtils.joinRide("Max Crane", phone: "3103103100", direction: "both",  rideId: "56aa9943507b61d912aad125")
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        ServerUtils.getRidesByGCMToken(gcmId, inserter: insertRide, afterFunc: finishRideInsert)
        ServerUtils.loadResources("event", inserter: insertEvent, afterFunc: finishInserting)
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        ServerUtils.getRidesByGCMToken(gcmId, inserter: insertNewRide, afterFunc: finishRefresh)

        
    }
    
    func finishRideInsert(){
        rides.sortInPlace({ (lRide: Ride, rRide: Ride) -> Bool in
        
            if(lRide.monthNum < rRide.monthNum){
            return true
            }
            else if(lRide.monthNum > rRide.monthNum){
            return false
            }
            
            if(lRide.day < rRide.day){
            return true
            }
            else if(lRide.day > rRide.day){
            return false
            }
            return false
        })
    
        self.tableView.reloadData()
    }
 
    
    
    func finishRefresh(){
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func insertNewRide(dict : NSDictionary){
        let newRide = Ride(dict: dict)
        
        //if there is no ride...add it
        if(!rides.contains(newRide!)){
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        }
        //else remove the old one and put in the new one
        //which may contain updated ride data
        else{
            let index = rides.indexOf(newRide!)
            rides.removeAtIndex(index!)
        }
        
        //in either case we insert the ride
        rides.insert(newRide!, atIndex: 0)
        
    }
    
    func insertRide(dict : NSDictionary) {
        //create ride
        let newRide = Ride(dict: dict)
        
        //insert into ride array
        rides.insert(newRide!, atIndex: 0)
        
        rides.sortInPlace({ (lRide: Ride, rRide: Ride) -> Bool in
            
            if(lRide.monthNum < rRide.monthNum){
                return true
            }
            else if(lRide.monthNum > rRide.monthNum){
                return false
            }
            
            if(lRide.day < rRide.day){
                return true
            }
            else if(lRide.day > rRide.day){
                return false
            }
            return false
        })
        
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
            if(event.id != nil && event.id == id){
                return event.name!
            }
        }

        return "Max's Golf Lessons"
    }
    
    func getEventForEventId(id : String)->Event{
        
        for event in events{
            if(event.id != nil && event.id == id){
                return event
            }
        }

        return Event(id: "123", name: "Erica's Golf Lessons", image: nil, startDate: "mon", endDate: "sat", street: "1123 Crap St.", suburb: "LA", postcode: "93401", description: "Come learn how to golf", url: "google.com", imageUrl: "idk.com")!
        //return Event(name: "Max's Golf Lessons", id: "notarealid")!
        
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
        if(ride.gcmId == self.gcmId){
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
            let cell = tableView.dequeueReusableCellWithIdentifier("ride", forIndexPath: indexPath) as! RideTableViewCell
        
        
            tappedRide = rides[indexPath.row]
            tappedEvent = getEventForEventId((tappedRide?.eventId)!)
        
        
            if(tappedRide?.gcmId == self.gcmId){
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
            yourNextViewController.passengers = tappedRide!.passengers
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

