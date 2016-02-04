//
//  TempEventTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 2/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class TempEventTableViewController: UITableViewController {
    
    //MARK: Properties
    var events = [Event]()
    
    var selectedEvent: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ServerUtils.loadResources("event", inserter: insertEvent)
    }
    
    func insertEvent(dict : NSDictionary) {
        events.insert(Event(dict: dict)!, atIndex: 0)
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PoopyTest"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TempEventTableViewCell
        
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //this is different than events...
        if segue.identifier == "saveSelectedEvent" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)
                if let index = indexPath?.row {
                    selectedEvent = events[index]
                }
            }
        }
        
    }
    
}
