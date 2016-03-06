//
//  FilterByEventViewController.swift
//  Cru
//
//  Created by Max Crane on 2/17/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress


class FilterByEventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    //var rides = ["ride1", "ride2"]
    var events = [Event]()
    var filteredRides = [Ride]()
    var allRides = [Ride]()
    
    var selectedEvent: Event?
    var selectedRide: Ride?

    @IBOutlet weak var rideTable: UITableView!
    @IBOutlet weak var eventPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make pickerview and tableview recognize this class
        //as their delegate and data source
        rideTable.delegate = self
        rideTable.dataSource = self
        
        eventPicker.delegate = self
        eventPicker.dataSource = self
        
        navigationItem.title = "Available Rides"
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        ServerUtils.loadResources("event", inserter: insertEvent, afterFunc: loadRides)
        
    }

    func loadEvents(afterFunc: ()->Void){
        ServerUtils.loadResources("event", inserter: insertEvent, afterFunc: afterFunc)
    }
    
    func loadRides(){
        ServerUtils.loadResources("ride", inserter: insertRide, afterFunc: showRides)
    }
    
    func showRides(){
        if(events.count != 0 && self.selectedEvent == nil){
            filterRidesByEventId(events[0].id)
            self.selectedEvent  = events[0]
            
        }
        else if(events.count != 0){
            filterRidesByEventId(self.selectedEvent!.id)
        }
        else{
            print("this shouldn't happen")
        }
        
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }
    
    func insertEvent(dict: NSDictionary){
        events.append(Event(dict: dict)!)
        eventPicker.reloadAllComponents()
    }
    func insertRide(dict: NSDictionary){
        allRides.append(Ride(dict: dict)!)
    }
    
    func filterRidesByEventId(eventId: String){
        filteredRides.removeAll()
        
        for ride in allRides{
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
        var cell = tableView.dequeueReusableCellWithIdentifier("rideCell") as! OfferedRideTableViewCell
        
        let thisRide = filteredRides[indexPath.row]
        cell.month.text = thisRide.month
        cell.day.text = String(thisRide.day)
        cell.time.text = thisRide.time
        
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
    
    func selectVal(event: Event){
        let ndx = events.indexOf(event)
        eventPicker.selectRow(ndx!, inComponent: 0, animated: true)
        filterRidesByEventId(events[ndx!].id)
        self.selectedEvent = events[ndx!]
        self.rideTable.reloadData()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(row < events.count){
            self.filterRidesByEventId(events[row].id)
            self.selectedEvent = events[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return events.count
    }
    
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return events[row].name
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
                if let vc = segue.destinationViewController as? JoinRideViewController where segue.identifier == "joinSegue" {
//                    print("ride was assigned")
//                    if(selectedRide != nil) {
//                        vc.ride = selectedRide!
//        
//                    }
                    vc.ride = self.selectedRide
                    vc.event = self.selectedEvent
                    
        
                    //vc.details.text = selectedRide?.getDescription()
                }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
