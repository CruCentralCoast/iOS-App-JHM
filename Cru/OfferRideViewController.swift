//
//  OfferRideViewController.swift
//  Cru
//
//  Created by Max Crane on 4/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import RadioButton
import SwiftValidator
import ActionSheetPicker_3_0
import MapKit
import LocationPicker
import MRProgress

class OfferRideViewController: UIViewController, ValidationDelegate, UIPopoverPresentationControllerDelegate{
    @IBOutlet weak var numSeats: UILabel!
    @IBOutlet weak var roundTripButton: RadioButton!
    @IBOutlet weak var toEventButton: RadioButton!
    @IBOutlet weak var fromEventButton: RadioButton!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameFieldError: UILabel!
    @IBOutlet weak var chooseEventButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneFieldError: UILabel!
    @IBOutlet weak var pickupDate: UILabel!
    @IBOutlet weak var pickupTime: UILabel!
    @IBOutlet weak var pickupLocation: UILabel!
    @IBOutlet weak var eventName: UILabel!
    
    var checkImage = UIImage(named: "checked")
    var uncheckImage = UIImage(named: "unchecked")
    let validator = Validator()
    var events = [Event]()
    var chosenEvent:Event?
    var direction:String?
    var location: Location! {
        didSet {
            pickupLocation.text? = location.address
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundTripButton.setImage(checkImage, forState: UIControlState.Selected)
        roundTripButton.setImage(uncheckImage, forState: UIControlState.Normal)
        
        toEventButton.setImage(checkImage, forState: UIControlState.Selected)
        toEventButton.setImage(uncheckImage, forState: UIControlState.Normal)
        
        fromEventButton.setImage(checkImage, forState: UIControlState.Selected)
        fromEventButton.setImage(uncheckImage, forState: UIControlState.Normal)
        
        stepper.value = 1
        
        validator.registerField(nameField, errorLabel: nameFieldError, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(phoneField, errorLabel: phoneFieldError, rules: [RequiredRule(), PhoneNumberRule()])
        
        nameFieldError.text = ""
        phoneFieldError.text = ""
        eventName.text = ""
        pickupLocation.text = ""
        pickupTime.text = ""
        pickupDate.text = ""

        loadEvents()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numSeatsChanged(sender: UIStepper) {
        var val =  Int(sender.value).description

        if(val == "0"){
            val = "1"
            sender.value = 1
        }
        
        numSeats.text = val
        
    }

    
    @IBAction func touchedButton(sender: AnyObject) {
        if let sendr = sender as? RadioButton{
            let text = sendr.titleLabel?.text
            if(text == "  Round-Trip"){
                direction = "Round-Trip"
            }
            else if(text == "  To Event"){
                direction =  "To Event"
            }
            else if(text == "  From Event"){
                direction = "From Event"
            }
        }
    }
    
    
    func validationSuccessful() {
        
        if chosenEvent == nil{
            return
        }
        if direction == nil{
            return
        }
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        RideUtils.postRideOffer(chosenEvent!.id, name: (nameField.text)!, phone: phoneField.text!, seats: Int(numSeats.text!)!, location: location.getLocationAsDict(location), radius: 0, direction: direction!, handler:  wasSuccess, idhandler: {id in})
        
        
    }
    func wasSuccess(sucess: Bool){
        print(sucess)
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
    }
    func resetLabel(field: UITextField, error: UILabel){
        field.layer.borderColor = UIColor.clearColor().CGColor
        field.layer.borderWidth = 0.0
        error.text = ""
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        var numValid = true
        var nameValid = true
        
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
            
            if(field == nameField){
                nameValid = false
            }
            if(field == phoneField){
                numValid = false
            }
        }
        
        if(nameValid){
            resetLabel(nameField, error: nameFieldError)
        }
        if(numValid){
            resetLabel(phoneField, error: phoneFieldError)
        }
    }
    
    @IBAction func submitPressed(sender: UIButton) {
        validator.validate(self)
    }
    
    @IBAction func choosePickupLocation(sender: AnyObject) {
        let locationPicker = LocationPickerViewController()
        
        if self.location != nil {
            locationPicker.location = self.location
        }
        
        locationPicker.completion = { location in
            self.location = location
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func chooseEventSelected(sender: AnyObject) {
        self.performSegueWithIdentifier("eventPopover", sender: self)
    }
    
    @IBAction func chooseTime(sender: UIButton) {
        let datePicker = ActionSheetDatePicker(title: "Time:", datePickerMode: UIDatePickerMode.Time, selectedDate: NSDate(), target: self, action: "datePicked:", origin: sender.superview!.superview)
        
        datePicker.minuteInterval = 15
        datePicker.showActionSheetPicker()
    }
    
    @IBAction func chooseDate(sender: AnyObject) {
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.Date, selectedDate: NSDate(), doneBlock: {
            picker, value, index in
            
            if let val = value as? NSDate{
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day,.Month,.Year], fromDate: val)

                let month = String(components.month)
                let day = String(components.day)
                let year = String(components.year)

                self.pickupDate.text = month + "/" + day + "/" + year
            }
            
            
            return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: self.view)

        
        datePicker.showActionSheetPicker()
    }


    
    func datePicked(obj: NSDate) {
        if let val = obj as? NSDate{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "h:mm a"
            pickupTime.text = formatter.stringFromDate(val)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "eventPopover"{
            var vc  = segue.destinationViewController as? EventsModalTableViewController
            vc?.events = events
            vc?.vc = self
            var controller = vc?.popoverPresentationController
            if(controller != nil){
                controller?.delegate = self
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    // MARK: - Table view data source
    func loadEvents(){
        ServerUtils.loadResources(.Event, inserter: insertEvent)
    }
    
    func insertEvent(dict : NSDictionary) {
        events.insert(Event(dict: dict)!, atIndex: 0)
        //self.tableView.insertRowsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)], withRowAnimation: .Automatic)
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
