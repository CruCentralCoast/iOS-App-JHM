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
        //loadSampleEvents()
        
        DBUtils.loadResources("event", inserter: insertEvent)
        //loadSampleEvents()
    }
    
    func insertEvent(dict : NSDictionary) {
        self.tableView.beginUpdates()
        events.insert(Event(dict: dict)!, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
        self.tableView.endUpdates()
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
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        let months = dateFormatter.shortMonthSymbols
        let monthShort = months[event.month!-1]
        
        cell.monthLabel.text = monthShort.uppercaseString
        
        cell.dateLabel.text = String(event.startDay!)
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

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }    
    }


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
