//
//  EventsTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 4/28/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    var events = [Event]()
    let curDate = NSDate()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        CruClients.getEventUtils().loadEvents(insertEvent, completionHandler: finishInserting)
    }

    //insert helper function for inserting event data
    private func insertEvent(dict: NSDictionary) {
        let event = Event(dict: dict)!
        let cmpResult = curDate.compare(event.endNSDate)
        
        //check if the event has happened yet. If it hasnt then add it
        if cmpResult == NSComparisonResult.OrderedAscending || cmpResult == NSComparisonResult.OrderedSame {
            self.events.insert(event, atIndex: 0)
        }
    }
    
    //helper function for finishing off inserting event data
    private func finishInserting(success: Bool) {
        self.events.sortInPlace(Event.sortEventsByDate)
        self.tableView!.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let event = events[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath) as! EventTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.event = event
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView!.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let event = events[indexPath.row]
        
        if event.imageUrl == "" {
            return 150.0
        }
        else {
            return 305.0       
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventDetails" {
            let eventDetailViewController = segue.destinationViewController as! EventDetailsViewController
            let selectedEventCell = sender as! EventTableViewCell
            let indexPath = self.tableView!.indexPathForCell(selectedEventCell)!
            let selectedEvent = events[indexPath.row]
            
            eventDetailViewController.event = selectedEvent
        }
    }
}
