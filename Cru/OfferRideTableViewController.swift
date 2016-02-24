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
import SwiftValidator
import MRProgress

class OfferRideTableViewController: CreateRideViewController, UITextFieldDelegate, ValidationDelegate {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var numAvailableSeatsLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var availableSeatsStepper: UIStepper!
    @IBOutlet weak var pickupDateTimePicker: DatePickerCell!
    
    //validator object
    let validator = Validator()
    
    var event: Event! {
        didSet {
            eventNameLabel.text? = event.name!
            self.formHasBeenEdited = true
            
            // Set date/time of ride to event date/time
            let date = "\(event.year!)-\(event.month!)-\(event.startDay!)"
            pickupDateTimePicker.date = NSDate(dateString: date)
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
        
        self.pickupDateTimePicker.leftLabel.text = "Pickup Date"
        validator.registerField(fullName, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(phoneNumber, rules: [RequiredRule(), PhoneNumberRule()])
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
        validator.validate(self)
    }
    
    func validationSuccessful() {
        if isFormFilledOut() {
            MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
            RideUtils.postRideOffer(event.id!, name: fullName.text!, phone: phoneNumber.text!, seats: Int(numAvailableSeatsLabel.text!)!, location: location.getLocationAsDict(location), radius: 0, direction: "to")
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            
            let cancelRideAlert = UIAlertController(title: "Ride Offered", message: "Thank you your offered ride has been created!", preferredStyle: UIAlertControllerStyle.Alert)
            
            cancelRideAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: performBackAction))
            presentViewController(cancelRideAlert, animated: true, completion: nil)
        }
        else {
            let cancelRideAlert = UIAlertController(title: "Error", message: "Ride offer form has not been completely filled out. Please fill out the entire form.", preferredStyle: UIAlertControllerStyle.Alert)
            
            cancelRideAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(cancelRideAlert, animated: true, completion: nil)
        }
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }
    
    //Method for determining if the form has been completely filled out
    private func isFormFilledOut() -> Bool {
        if (self.event == nil ||
            self.location == nil ||
            Int(self.numAvailableSeatsLabel.text!)! <= 0) {
                
            return false
        }
        
        return true
    }
}

//Temporary extension (Should move this later)
extension NSDate {
    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

extension Location {
    func getLocationAsDict(loc: Location) -> NSDictionary {
        print(loc.address)
        return [
            "address": loc.address
        ]
    }
}
