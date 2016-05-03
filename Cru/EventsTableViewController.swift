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
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil{
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //load events
        CruClients.getServerClient().getData(.Event, insert: insertEvent, completionHandler: finishInserting)
    }
    
    //insert helper function for inserting event data
    private func insertEvent(dict: NSDictionary) {
        self.events.insert(Event(dict: dict)!, atIndex: 0)
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
        cell.event = event
        
        return cell
    }
}
