//
//  EditRideViewController.swift
//  Cru
//
//  Created by Max Crane on 5/3/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MapKit
import LocationPicker
import SwiftValidator


class EditRideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let eventLabel = "Event:"
    let departureDateLabel = "Departure Date:"
    let departureTimeLabel = "Departure Time:"
    let addressLabel = "Departure Address:"
    let seatsLabel = "Number of Seats:"
    let nameLabel = "Name:"
    let phoneLabel = "Phone Number:"
    
    var event : Event!
    var ride : Ride!
    var options = [EditableItem]()
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var driverNumber: UITextField!
    var timeValue: UILabel!
    var dateValue: UILabel!
    var addressValue: UILabel!
    var seatsValue: UITextView!
    var nameValue: UITextView!
    var numberValue: UITextView!
    let validator = Validator()
    var hasUserEdited = false
    var location: Location! {
        didSet {
            addressValue.text? = location.address
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateOptions()
    }
    
    
    func populateOptions(){
        options.append(EditableItem(itemName: eventLabel, itemValue: event.name, itemEditable: false, itemIsText: false))
        options.append(EditableItem(itemName: departureTimeLabel, itemValue: ride.getTime(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: departureDateLabel, itemValue: ride.getDate(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: addressLabel, itemValue: ride.getCompleteAddress(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: seatsLabel, itemValue: String(ride.seats), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: nameLabel, itemValue: String(ride.driverName), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: phoneLabel, itemValue: String(ride.driverNumber), itemEditable: true, itemIsText: true))
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? EditCell
        let option = options[indexPath.row]
        
        cell?.contentType.text = option.itemName
        cell?.contentValue.text = option.itemValue
        cell?.editButton.setTitle(option.itemName, forState: .Normal)
        
        if option.itemIsText! {
            cell?.contentValue.hidden = true
            cell?.contentTextField.hidden = false
            cell?.contentTextField.text = option.itemValue
        }
        else{
            cell?.contentTextField.hidden = true
            cell?.contentValue.hidden = false
        }
        
        if(cell?.contentType.text == departureTimeLabel){
            timeValue = cell?.contentValue
        }
        else if(cell?.contentType.text == departureDateLabel){
            dateValue = cell?.contentValue
        }
        else if(cell?.contentType.text == seatsLabel){
            cell?.contentTextField.keyboardType = .NumberPad
            seatsValue = cell?.contentTextField
        }
        else if(cell?.contentType.text == addressLabel){
            addressValue = cell?.contentValue
        }
        else if(cell?.contentType.text == nameLabel){
            nameValue = cell?.contentTextField
        }
        else if(cell?.contentType.text == phoneLabel){
            cell?.contentTextField.keyboardType = .NumberPad
            numberValue = cell?.contentTextField
        }
        
        cell?.editButton.hidden = !(option.itemEditable)
        
    
        return cell!
    }

    @IBAction func editPressed(sender: UIButton) {
        let editChoice = sender.currentTitle
        hasUserEdited = true
        
        switch editChoice!{
            
            case departureTimeLabel:
                TimePicker.pickTime(self)
            case departureDateLabel:
                TimePicker.pickDate(self, handler: chooseDateHandler)
            case addressLabel:
                choosePickupLocation(self)
            case nameLabel:
                nameValue.becomeFirstResponder()
            case phoneLabel:
                numberValue.becomeFirstResponder()
            case seatsLabel:
                seatsValue.becomeFirstResponder()
            default:
                print("k")
        }
        
    }
    
    func chooseDateHandler(month : Int, day : Int, year : Int){
        let curDate = ride.date
        
        
        let dateStr = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "MM d yyyy"
        
        //if date formatter returns nil return the current date/time
        if let date = dateFormatter.dateFromString(String(month) + " " + String(day) + " " + String(year)) {
            ride.date = date
            self.dateValue.text = ride.getDate()
            ride.date = curDate
        }
    }
    
    func datePicked(obj: NSDate){
        if let val = obj as? NSDate{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "h:mm a"
            timeValue.text = formatter.stringFromDate(val)
        }
    }
    
    func choosePickupLocation(sender: AnyObject) {
        let locationPicker = LocationPickerViewController()
        
        if self.location != nil {
            locationPicker.location = self.location
        }
        
        locationPicker.completion = { location in
            self.location = location
        }
        
        navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    

    @IBAction func savePressed(sender: AnyObject) {
        
        if(seatsValue != nil){
            ride.seats = Int(seatsValue.text)!
        }
        
        if(timeValue != nil){
            ride.time = timeValue.text!
        }
        
        
        let timeVal = timeValue.text
        let dateVal = dateValue.text
        var timeDate: NSDate?
        var dateDate: NSDate?
        
        
        
        let dateStr = ""
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        //if date formatter returns nil return the current date/time
        if let date = dateFormatter.dateFromString(dateVal!) {
            dateDate = date
        }

        
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "h:mm a"
        
        //if date formatter returns nil return the current date/time
        if let date = dateFormatter.dateFromString(timeVal!) {
            timeDate = date
        }
        
        var components = GlobalUtils.dateComponentsFromDate(dateDate!)
        ride.day = (components?.day)!
        ride.monthNum = (components?.month)!
        ride.year = (components?.year)!
        
        components = GlobalUtils.dateComponentsFromDate(timeDate!)
        ride.hour = (components?.hour)!
        ride.minute = (components?.minute)!
        
        
        
        if(location != nil){
            var map = location.getLocationAsDict(location)
            ride.postcode = map[LocationKeys.postcode] as! String
            ride.state = map[LocationKeys.state] as! String
            ride.suburb = map[LocationKeys.suburb] as! String
            ride.street = map[LocationKeys.street1] as! String
        }
        
        if (nameValue != nil){
            ride.driverName = nameValue.text!
        }
        if (numberValue != nil){
            ride.driverNumber = numberValue.text!
        }
        
        var k = ride.getTimeInServerFormat()
        
        CruClients.getRideUtils().patchRide(ride.id, params: [RideKeys.driverName: ride.driverName, RideKeys.driverNumber: ride.driverNumber, RideKeys.time : ride.getTimeInServerFormat(), RideKeys.seats: ride.seats, LocationKeys.loc: [LocationKeys.postcode: ride.postcode, LocationKeys.state : ride.state, LocationKeys.street1 : ride.street, LocationKeys.suburb: ride.suburb, LocationKeys.country: ride.country]], handler: handlePostResult)
    }
    
    func handlePostResult(ride: Ride?){
        if(ride?.hour != -1){
            let alert = UIAlertController(title: "Ride updated successfully", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Could not update ride", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
