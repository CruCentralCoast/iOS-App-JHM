//
//  OfferRideTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 2/3/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import DatePickerCell

class OfferRideTableViewController: CreateRideViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var numSeatsInCar: UITextField!
    @IBOutlet weak var eventNameLabel: UILabel!
    
    var event: Event! {
        didSet {
            eventNameLabel.text? = event.name!
            self.formHasBeenEdited = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up delegate for testing if fields have changed
//        fullName.delegate = self
//        fullName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
//        
//        phoneNumber.delegate = self
//        phoneNumber.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
//        numSeatsInCar.delegate = self
//        numSeatsInCar.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if (cell.isKindOfClass(DatePickerCell)) {
            return (cell as! DatePickerCell).datePickerHeight()
        }
    
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    // Override of table view for creating a date picker cell in the appropriate location
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if cell.isKindOfClass(DatePickerCell) {
            let datePickerTableViewCell = cell as! DatePickerCell
            datePickerTableViewCell.selectedInTableView(tableView)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // Handler for changing "did edit form" flag inherited from CreateRideViewController to true
    func textFieldDidChange(textField: UITextField) {
        self.formHasBeenEdited = true
    }
    
    // Function for sending the selected event to this view controller.
    // sets the selected event to the event that was selected in the event table view controller.
    @IBAction func unwindWithSelectedEvent(segue: UIStoryboardSegue) {
        if let eventPickerViewController = segue.sourceViewController as? TempEventTableViewController, selectedEvent = eventPickerViewController.selectedEvent {
            event = selectedEvent
        }
    }
}
