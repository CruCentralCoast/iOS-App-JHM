//
//  OfferRideTableViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 2/3/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import DatePickerCell
import MapKit
import LocationPicker

class OfferRideTableViewController: CreateRideViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var numAvailableSeatsLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var availableSeatsStepper: UIStepper!
    @IBOutlet weak var pickupDateTimePicker: DatePickerCell!
    
    var event: Event! {
        didSet {
            eventNameLabel.text? = event.name!
            self.formHasBeenEdited = true
        }
    }
    var location: Location! {
        didSet {
            locationAddressLabel.text? = location.address
            self.formHasBeenEdited = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        configureTapGestureForKeyboardDismissal()
        configureAvailableSeatsStepper()
        
        //set up delegate for testing if fields have changed
        fullName.delegate = self
        fullName.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        phoneNumber.delegate = self
        phoneNumber.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    private func configureAvailableSeatsStepper() {
        availableSeatsStepper.wraps = true
        availableSeatsStepper.autorepeat = true
        availableSeatsStepper.maximumValue = 100
    }
    
//    private func configureTapGestureForKeyboardDismissal() {
//        let gestureRec = UITapGestureRecognizer()
//        gestureRec.addTarget(self, action: "didTapView:")
//        self.view.addGestureRecognizer(gestureRec)
////    }
//    
//    //resigns responder for keyboards
//    func didTapView(sender: UIView) {
//        if fullName.isFirstResponder() {
//            fullName.resignFirstResponder()
//        }
//        
//        if phoneNumber.isFirstResponder() {
//            phoneNumber.resignFirstResponder()
//        }
//    }
    
    //implements delegate method for returning text field
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
            print(datePickerTableViewCell.date)
        }
        
        //check for index of location picker
        if cell.reuseIdentifier == "pickup" {
            let locationPicker = LocationPickerViewController()
            
            if self.location != nil {
                locationPicker.location = self.location
            }
            
            locationPicker.completion = { location in
                self.location = location
            }
            
            navigationController?.pushViewController(locationPicker, animated: true)
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
    
    // Action for adding/subtracting from the available seats
    @IBAction func availableSeatsStepperChanged(sender: UIStepper) {
        numAvailableSeatsLabel.text = Int(sender.value).description
    }
    
    // Action for submitting an offer for a ride
    @IBAction func submitOfferRideForm(sender: AnyObject) {
        //verify form is correct and submit it through the API
    }
}
