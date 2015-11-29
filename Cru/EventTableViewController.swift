//
//  EventTableViewController.swift
//  Cru
//
//  Created by Erica Solum on 11/25/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    //MARK: Properties
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadSampleEvents()
    }
    
    func loadSampleEvents()
    {
        let descriptionSample = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        
        let photo1 = UIImage(named: "event1")!
        let event1 = Event(name: "Dinners for 8", image: photo1, month: "November", date: "13", startTime: "6:00", endTime: "9:00", startamORpm: "PM", endamORpm: "PM", location: "Various students' houses", description: descriptionSample)!
        
        let photo2 = UIImage(named: "event2")!
        let event2 = Event(name: "Crossroads", image: photo2, month: "January", date: "20", startTime: "4:00", endTime: "12:00", startamORpm: "PM", endamORpm: "AM", location: "Hyatt Westlake Village", description: descriptionSample)!
        
        let photo3 = UIImage(named: "event3")!
        let event3 = Event(name: "Sophomore Social", image: photo3, month: "February", date: "20", startTime: "6:00", endTime: "9:00", startamORpm: "PM", endamORpm: "PM", location: "233 Patricia Drive, San Luis Obispo, CA", description: descriptionSample)!
        
        events += [event1, event2, event3]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! EventTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let event = events[indexPath.row]
        
        //Creating the abbreviated version of the month to be displayed
        let index1 = event.month.startIndex.advancedBy(3)
        let abbrMonth = event.month.substringToIndex(index1)
        cell.monthLabel.text = abbrMonth.uppercaseString
        
        cell.dateLabel.text = event.date
        cell.nameLabel.text = event.name
        
        return cell
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
        if let selectedEventCell = sender as? EventTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedEventCell)!
            let selectedEvent = events[indexPath.row]
            eventDetailViewController.event = selectedEvent
        }
        
    }


}
