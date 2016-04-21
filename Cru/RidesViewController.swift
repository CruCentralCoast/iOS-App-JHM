//
//  RidesViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 4/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress
import DZNEmptyDataSet


class RidesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    let roundTrip = "round-trip"
    let roundTripDirection = "both"
    let fromEvent = "from event"
    let toEvent = "to event"
    let driver = "driver"
    let rider = "rider"
    var refreshControl: UIRefreshControl!
    var rides = [Ride]()
    var events = [Event]()
    var tappedRide = Ride?()
    var tappedEvent = Event?()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var ridesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.ridesTableView.addSubview(self.refreshControl)
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        RideUtils.getMyRides(insertRide, afterFunc: finishRideInsert)
        ServerUtils.loadResources(.Event, inserter: insertEvent, afterFunc: finishInserting)
        
        self.ridesTableView.emptyDataSetSource = self
        self.ridesTableView.emptyDataSetDelegate = self
        self.ridesTableView.tableFooterView = UIView()
    }
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Pacman")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "offerridesegue"{
            let destVC = segue.destinationViewController as? OfferRideViewController
            destVC?.rideVC = self
        }
        if segue.identifier == "findridesegue"{
            let destVC = segue.destinationViewController as? FilterByEventViewController
            destVC?.rideVC = self
        }
        if(segue.identifier == "riderdetailsegue") {
            
            let yourNextViewController = (segue.destinationViewController as! RiderRideDetailViewController)
            
            yourNextViewController.ride = tappedRide
            yourNextViewController.event = tappedEvent
            yourNextViewController.rideVC = self
        }
        
        if(segue.identifier == "driverdetailsegue") {
            
            let yourNextViewController = (segue.destinationViewController as! DriverRideDetailViewController)
            
            yourNextViewController.ride = tappedRide
            yourNextViewController.event = tappedEvent
            yourNextViewController.rideVC = self
        }
    }
    
    func refresh(sender:AnyObject)
    {
        rides.removeAll()
        self.ridesTableView.reloadData()
        RideUtils.getMyRides(insertNewRide, afterFunc: finishRefresh)
    }
    
    func finishRideInsert(){
        rides.sortInPlace()
        self.ridesTableView.reloadData()
    }
    
    func finishRefresh(){
        rides.sortInPlace()
        self.ridesTableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    func insertNewRide(dict : NSDictionary){
        let newRide = Ride(dict: dict)
        rides.insert(newRide!, atIndex: 0)
        self.ridesTableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    func insertRide(dict : NSDictionary) {
        //create ride
        let newRide = Ride(dict: dict)
        
        //insert into ride array
        rides.insert(newRide!, atIndex: 0)
        
        rides.sortInPlace()
        
        self.ridesTableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    
    func finishInserting(){
        self.ridesTableView.beginUpdates()
        
        
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        
        self.ridesTableView.reloadData()
        self.ridesTableView.endUpdates()
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
}
