//
//  RidesTableViewController.swift
//  Cru
//
//  Created by Max Crane on 1/28/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit


class RidesTableViewController: UITableViewController {
    //let rides: [String] = ["driving", "riding"]
    var rides = [Ride]()
    var events = [Event]()
    
    //TODO: Get name of user from device
    let myName = "Daniel Toy"
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DBUtils.loadResources("ride", inserter: insertRide)
        DBUtils.loadResources("event", inserter: insertEvent)
        //TODO: Get rides from http://ec2-52-32-197-212.us-west-2.compute.amazonaws.com:3000/api/ride/list

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func insertRide(dict : NSDictionary) {
        self.tableView.beginUpdates()
        
        let rideId = dict["_id"] as! String
        let driverName = dict["driverName"] as! String
        
        var eventId = "max's gold lessons"
        
        if (dict.objectForKey("event") != nil){
            eventId = dict.objectForKey("event") as! String
        }
        
        let newRide = Ride(id: rideId, driverName: driverName, eventId: eventId)
        rides.insert(newRide!, atIndex: 0)
        
        //campuses.sortInPlace()
        
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    func insertEvent(dict : NSDictionary) {
        var name = "max's golfing"
        var id = "563b11135e926d03001ac15c"
        
        if (dict.objectForKey("_id") != nil){
            id = dict.objectForKey("_id") as! String
        }
        
        if (dict.objectForKey("name") != nil){
            name = dict.objectForKey("name") as! String
        }
        
        
        
        events.insert(Event(name: name, id: id)!, atIndex: 0)
    }
    
    func getEventNameForEventId(id : String)->String{
        print("id is \(id)")
        
        for event in events{
            if(event.id != nil && event.id == id){
                return event.name!
            }
        
     
        }
        
        
        return "Max's Golf Lessons"
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Rides"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rides.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ride", forIndexPath: indexPath) as! RideTableViewCell

        //cell.textLabel?.text = rides[indexPath.row].driverName
        // Configure the cell...
        let ride = rides[indexPath.row]
        
        if(ride.driverName == myName){
            cell.rideType.text = "driver"
            cell.icon.image  = UIImage(named: "driver")
            
        }
        else
        {
            cell.rideType.text = "rider"
            cell.icon.image = UIImage(named: "rider")
        }
        
        cell.eventTitle.text = getEventNameForEventId(ride.eventId)
        
        return cell
    }

    @IBAction func addRideSelected(sender: AnyObject) {
        let newRideAlert = UIAlertController(title: "New Ride", message: "select ride type", preferredStyle: UIAlertControllerStyle.Alert)
        newRideAlert.addAction(UIAlertAction(title: "Offer Ride", style: .Default, handler: handleOfferRide))
        newRideAlert.addAction(UIAlertAction(title: "Get Ride", style: .Default, handler: handleFindRide))
        newRideAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(newRideAlert, animated: true, completion: nil)
        
        //print("adding ride!")
    }
    
    func handleOfferRide(action: UIAlertAction){
        self.performSegueWithIdentifier("offerridesegue", sender: self)
        
    }
    
    func handleFindRide(action: UIAlertAction){
        self.performSegueWithIdentifier("findridesegue", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if(cell.textLabel?.text == myName){
                self.performSegueWithIdentifier("driverdetailsegue", sender: self)
            }
            else{
                self.performSegueWithIdentifier("riderdetailsegue", sender: self)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
