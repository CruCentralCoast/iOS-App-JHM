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


class EditRideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    let eventLabel = "Event:"
    let departureDateLabel = "Departure Date:"
    let departureTimeLabel = "Departure Time:"
    let addressLabel = "Departure Address:"
    let seatsLabel = "Seats Offered:"
    let nameLabel = "Name:"
    let phoneLabel = "Phone Number:"
    let directionLabel = "Direction:"
    
    var event : Event!
    var ride : Ride!
    var options = [EditableItem]()
    var ridesVC: RidesViewController?
    var rideDetailVC: DriverRideDetailViewController?
    var table: UITableView?
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var driverNumber: UITextField!
    var CLocation: CLLocation?
    var timeValue: UILabel!
    var dateValue: UILabel!
    var directionValue: UILabel!
    var addressValue: UILabel!
    var pickupRadius: UITextView!
    var seatsValue: UITextView!
    var nameValue: UITextView!
    var numberValue: UITextView!
    let validator = Validator()
    var hasUserEdited = false
    var directionCell: UITableViewCell?
    var directionCellPath: NSIndexPath?
    var location: Location! {
        didSet {
            addressValue.text? = location.address
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Ride"
        populateOptions()
        getRideLocation()
    }
    
    
    func populateOptions(){
        options.append(EditableItem(itemName: eventLabel, itemValue: event.name, itemEditable: false, itemIsText: false))
        options.append(EditableItem(itemName: departureTimeLabel, itemValue: ride.getTime(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: departureDateLabel, itemValue: ride.getDate(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: addressLabel, itemValue: ride.getCompleteAddress(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: Labels.pickupRadius, itemValue: ride.getRadius(), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: directionLabel, itemValue: ride.getDirection(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: seatsLabel, itemValue: String(ride.seats), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: nameLabel, itemValue: String(ride.driverName), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: phoneLabel, itemValue: "", itemEditable: true, itemIsText: true))
        
        
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
            numberValue.delegate = self
            numberValue.text = PhoneFormatter.unparsePhoneNumber(ride.driverNumber)
        }
        else if(cell?.contentType.text == directionLabel){
            directionValue = cell?.contentValue
            directionCell = cell
            directionCellPath = indexPath
        }
        else if(cell?.contentType.text == Labels.pickupRadius){
            pickupRadius = cell?.contentTextField
        }
        
        cell?.editButton.hidden = !(option.itemEditable)
        table = tableView
    
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
            case directionLabel:
                self.performSegueWithIdentifier("direction", sender: self)
            case Labels.pickupRadius:
                self.performSegueWithIdentifier("radius", sender: self)
            default:
                print("k")
        }
        
    }

    func editRadius(){
        
    }
    
    func chooseDateHandler(month : Int, day : Int, year : Int){
        let curDate = ride.date
        
        
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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        timeValue.text = formatter.stringFromDate(obj)
    }
    
    func choosePickupLocation(sender: AnyObject) {
        let locationPicker = LocationPickerViewController()
        
        if self.location != nil {
            locationPicker.location = self.location
        }
        
        locationPicker.completion = { location in
            self.location = location
            self.CLocation = self.location.location
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
        
        if (dateDate != nil){
            if let components = GlobalUtils.dateComponentsFromDate(dateDate!){
                ride.day = (components.day)
                ride.monthNum = (components.month)
                ride.year = (components.year)
            }
        }
        
        if (timeDate != nil){
            if let components = GlobalUtils.dateComponentsFromDate(timeDate!){
                ride.hour = (components.hour)
                ride.minute = (components.minute)
            }
        }
        
        

        
        
        if(location != nil){
            let map = location.getLocationAsDict(location)
            
            if(map[LocationKeys.postcode] != nil){
                ride.postcode = map[LocationKeys.postcode] as! String
            }
            if(map[LocationKeys.postcode] != nil){
                ride.state = map[LocationKeys.state] as! String
            }
            if(map[LocationKeys.postcode] != nil){
                ride.suburb = map[LocationKeys.suburb] as! String
            }
            if(map[LocationKeys.postcode] != nil){
                ride.street = map[LocationKeys.street1] as! String
            }

        }
        
        if (nameValue != nil){
            ride.driverName = nameValue.text!
        }
        if (numberValue != nil){
            let parsedNum = PhoneFormatter.parsePhoneNumber(numberValue.text!)
            ride.driverNumber = parsedNum
        }
        
        var serverVal = ride.direction
        if(directionValue != nil){
            switch (directionValue.text){
            case Directions.from?:
                serverVal = "from"
            case Directions.to?:
                serverVal = "to"
            case Directions.both?:
                serverVal = "both"
            default:
                serverVal = ""
            }
        }
        
        
        let index1 = pickupRadius.text?.startIndex.advancedBy(2)
        let numMiles = pickupRadius.text?.substringToIndex(index1!)
        let trimmedString = numMiles!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        let milesInt = Int(trimmedString)
        
    
        CruClients.getRideUtils().patchRide(ride.id, params: [RideKeys.radius: milesInt!, RideKeys.driverName: ride.driverName, RideKeys.direction: serverVal, RideKeys.driverNumber: ride.driverNumber, RideKeys.time : ride.getTimeInServerFormat(), RideKeys.seats: ride.seats, LocationKeys.loc: [LocationKeys.postcode: ride.postcode, LocationKeys.state : ride.state, LocationKeys.street1 : ride.street, LocationKeys.suburb: ride.suburb, LocationKeys.country: ride.country]], handler: handlePostResult)
    }
    
    func handlePostResult(ride: Ride?){
        
        if(ride?.hour != -1){
            let alert = UIAlertController(title: "Ride updated successfully", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: {
                //self.navigationController?.popViewControllerAnimated(true)
            })
            ridesVC!.refresh(self)
            self.ride = ride
            
            rideDetailVC?.ride = ride
            rideDetailVC?.updateData()
            
        }
        else{
            let alert = UIAlertController(title: "Could not update ride", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    func handleDirectionChoice(choice: String){
        directionValue.text = choice
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "direction"){
            
            //uipopover magic
            let popoverVC = segue.destinationViewController
            let controller = popoverVC.popoverPresentationController
            popoverVC.preferredContentSize = CGSizeMake(self.view.frame.width - 30, 240)
            
            if(controller != nil){
                controller?.delegate = self
            }
            
            if let vc = popoverVC as? DirectionTVC{
                vc.handler = handleDirectionChoice
            }
            let fromRect:CGRect = self.table!.rectForRowAtIndexPath(directionCellPath!)
            controller!.sourceView = self.table
            controller!.sourceRect = fromRect
            controller!.permittedArrowDirections = .Any
        }
        else if(segue.identifier == "radius"){
            let vc = segue.destinationViewController as! PickRadiusViewController
            vc.ride = self.ride
            vc.setRadius = setRadius
            vc.numMiles = ride.radius
            vc.location = CLocation
            
            
        }
    }
    
    
    func setRadius(radius: Int){
        if(radius == 1){
            pickupRadius.text = String(radius) + " mile"
        }
        else{
            pickupRadius.text = String(radius) + " miles"
        }
        ride.radius = radius
    }
    
    
    func getRideLocation(){
        var initialLocation = CLLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = ride!.getCompleteAddress()
        
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            guard let response = response else {
                return
            }
            
            for item in response.mapItems {
                initialLocation = item.placemark.location!
  
                self.CLocation = initialLocation
            }
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if numberValue != nil {
            if textView == numberValue {
                let newString = (textView.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)
                let components = newString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
                
                let decimalString = components.joinWithSeparator("") as NSString
                let length = decimalString.length
                let hasLeadingOne = length > 0 && decimalString.characterAtIndex(0) == (1 as unichar)
                
                if length == 0 || (length > 10 && !hasLeadingOne) || length > 11 {
                    let newLength = (textView.text! as NSString).length + (text as NSString).length - range.length as Int
                    return (newLength > 10) ? false : true
                }
                var index = 0 as Int
                let formattedString = NSMutableString()
                
                if hasLeadingOne {
                    formattedString.appendString("1 ")
                    index += 1
                }
                if (length - index) > 3 {
                    let areaCode = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("(%@) ", areaCode)
                    index += 3
                }
                if length - index > 3 {
                    let prefix = decimalString.substringWithRange(NSMakeRange(index, 3))
                    formattedString.appendFormat("%@-", prefix)
                    index += 3
                }
                
                let remainder = decimalString.substringFromIndex(index)
                formattedString.appendString(remainder)
                textView.text = formattedString as String
                return false
            }
            else {
                return true
            }
        }
        
        return false
    }
    
    
    

}
