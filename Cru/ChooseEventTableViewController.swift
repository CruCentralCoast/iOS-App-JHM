//
//  TempEventTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 2/2/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class ChooseEventTableViewController: UITableViewController {
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Config.eventReuseIdentifier, forIndexPath: indexPath) as! ChooseEventTableViewCell
        
        // Fetches the appropriate meal for the data source layout.
        let event = events[indexPath.row]
        let startEventDate = GlobalUtils.dateComponentsFromDate(event.startNSDate)!
        let dateFormatter = NSDateFormatter()
        let months = dateFormatter.shortMonthSymbols
        
        cell.monthLabel.text = months[startEventDate.month - 1].uppercaseString
        cell.dateLabel.text = String(startEventDate.day)
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
