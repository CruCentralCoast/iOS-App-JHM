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

class OfferRideTableViewController: CreateRideViewController, UITextFieldDelegate, ValidationDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var numAvailableSeatsLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var availableSeatsStepper: UIStepper!
    @IBOutlet weak var pickupDateTimePicker: DatePickerCell!
    @IBOutlet weak var driverDirectionPickerView: UIPickerView!
    
    let directions = ["To Event", "From Event", "Both"]
    var selectedDirection: String = "To Event"
    
    //validator object
    let validator = Validator()
    
    var event: Event! {
        didSet {
            eventNameLabel.text? = event.name
            self.formHasBeenEdited = true
            
            // Set date/time of ride to event date/time
            pickupDateTimePicker.date = event.startNSDate
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
        
        driverDirectionPickerView.delegate = self
        driverDirectionPickerView.dataSource = self
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(row < directions.count){
            self.selectedDirection = directions[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return directions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return directions[row]
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
            
            RideUtils.postRideOffer(event.id, name: fullName.text!, phone: phoneNumber.text!, seats: Int(numAvailableSeatsLabel.text!)!, location: location.getLocationAsDict(location), radius: 0, direction: getDirection(), handler:  handleRequestResult, idhandler: {id in})
            
            MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            
            //display confirmation alert
            displayAlert(1, displayMessageAddOns: [])
        }
        else {
            displayAlert(0, displayMessageAddOns: ["None"])
        }
    }
    
    func handleRequestResult(result : Bool){
        
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        for (_, _) in validator.errors {
                //something here
        }
        
        displayAlert(0, displayMessageAddOns: ["FIELDS"])
    }
    
    private func displayAlert(displayCode: Int, displayMessageAddOns: [String]) {
        //display code 0 is an error in filling out the form
        if displayCode == 0 {
            let cancelRideAlert = UIAlertController(title: "Error", message: "Ride offer form has not been completely filled out. Please fill out the following fields: \n" + concatenateAllMessages(displayMessageAddOns), preferredStyle: UIAlertControllerStyle.Alert)
            
            cancelRideAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(cancelRideAlert, animated: true, completion: nil)
        }
        //display code 1 means the form was filled out correctly
        else {
            let cancelRideAlert = UIAlertController(title: "Ride Offered", message: "Thank you your offered ride has been created!", preferredStyle: UIAlertControllerStyle.Alert)
            
            cancelRideAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                action in
                
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                    //navController.popViewControllerAnimated(true)
                    
                    for vc in navController.viewControllers{
                        if let tvc = vc as? RidesTableViewController {
                            tvc.refresh(1)
                        }
                    }
                }
            }))
            presentViewController(cancelRideAlert, animated: true, completion: nil)
        }
    }
    
    //Concatenate all messages together in a string of messages
    private func concatenateAllMessages(messages: [String]) -> String {
        var finalMessage = ""
        
        for message in messages {
            finalMessage += message + "\n"
        }
        
        return finalMessage
    }
    
    // Function for returning a direction based off of what is picked in the diriver direction picker
    private func getDirection() -> String {
        if selectedDirection == "To Event" {
            return "to"
        }
        else if selectedDirection == "From Event" {
            return "from"
        }
        else {
            return "both"
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //check if we're going to event modal
        if segue.identifier == "pickEvent" {
            if let destinationVC = segue.destinationViewController as? EventModalViewController {
                destinationVC.eventModalClosure = { event in
                    self.event = event
                }
            }
        }
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
        var dict = [String:AnyObject]()
        if let street = loc.placemark.addressDictionary!["Street"] {
            dict["street1"] = street
        }
        if let state = loc.placemark.addressDictionary!["State"] {
            dict["state"] = state
        }
        if let zip = loc.placemark.addressDictionary!["ZIP"] {
            dict["postcode"] = zip
        }
        if let suburb = loc.placemark.addressDictionary!["SubAdministrativeArea"] {
            dict["suburb"] = suburb
        }
        return dict
        
    }
}
