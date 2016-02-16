//
//  FindRideTableTableViewController.swift
//  Cru
//
//  Created by Max Crane on 2/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class FindRideTableTableViewController: UITableViewController, UIPickerViewDelegate {

    //var events = ["Max's Golf Lessons", "Fall Retreat", "Bowling with Pete"]
    var events = [Event]()
    var curRide = "nope"
    var rideTVC = FilteredRidesTableViewController?()
    
    @IBOutlet weak var rideList: UIView!
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerUtils.loadResources("event", inserter: insertEvent, afterFunc: loadRides)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func insertEvent(dict: NSDictionary){
        events.append(Event(dict: dict)!)
        picker.reloadAllComponents()    
    }
    
    func loadRides(){
        if(rideTVC != nil){
            rideTVC?.filterRidesByEventId(events[0].id!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return events.count
    }
    
//    func setTVC(tvc: FilteredRidesTableViewController){
//        self.rideTVC = tvc
//    }
    

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return events[row].name
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(row < events.count){
            curRide = events[row].id!
            
            if(rideTVC != nil){
                rideTVC!.filterRidesByEventId(curRide)
            }
        }
        
        
    }
    
    func getEventId()->String{
        return curRide
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? FilteredRidesTableViewController where segue.identifier == "filterSegue" {
            rideTVC = vc
            vc.parentTVC = self
        }
        if let vc = segue.destinationViewController as? JoinRideViewController where segue.identifier == "joinSegue" {
            vc.ride = rideTVC?.selectedRide
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
