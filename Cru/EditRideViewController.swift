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

enum EditTags: Int {
    case Time
    case Date
    case Address
    case Radius
    case Direction
    case Seats
    case Name
    case Number
}

class EditRideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
//    let eventLabel = "Event:"
//    let departureDateLabel = "Departure Date:"
//    let departureTimeLabel = "Departure Time:"
//    let addressLabel = "Departure Address:"
//    let seatsLabel = "Seats Offered:"
//    let passengerLabel = "Passengers:"
//    let nameLabel = "Name:"
//    let phoneLabel = "Phone Number:"
//    let directionLabel = "Direction:"
    
    var event : Event!
    var ride : Ride!
    var options = [EditableItem]()
    var directionOption: EditableItem!
    var ridesVC: RidesViewController?
    var rideDetailVC: DriverRideDetailViewController?
    var table: UITableView?
    var passengers = [Passenger]()
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
    var passengerValue: UITextView!
    let validator = Validator()
    var hasUserEdited = false
    var directionCell: UITableViewCell?
    var directionCellPath: NSIndexPath?
    var location: Location! {
        didSet {
            addressValue.text? = location.address
            extractLocationFromView()
            updateOptions()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Edit Ride"
        ride.eventStartDate = event.startNSDate
        ride.eventEndDate = event.endNSDate
        populateOptions()
        getRideLocation()
    }
    
    
    func populateOptions(){
        options.append(EditableItem(itemName: Labels.eventLabel, itemValue: event.name, itemEditable: false, itemIsText: false))
        options.append(EditableItem(itemName: Labels.departureTimeLabel, itemValue: ride.getTime(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: Labels.departureDateLabel, itemValue: ride.getDate(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: Labels.addressLabel, itemValue: ride.getCompleteAddress(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: Labels.pickupRadius, itemValue: ride.getRadius(), itemEditable: true, itemIsText: true))
        directionOption = EditableItem(itemName: Labels.directionLabel, itemValue: ride.getDirection(), itemEditable: true, itemIsText: false)
        options.append(directionOption)
        options.append(EditableItem(itemName: Labels.seatsLabel, itemValue: String(ride.seats), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: Labels.passengers, itemValue: String(ride.passengers.count), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: Labels.nameLabel, itemValue: ride.driverName, itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: Labels.phoneLabel, itemValue: "", itemEditable: true, itemIsText: true))
    }
    
    func updateOptions(){
        for option in options{
            switch option.itemName{
                case Labels.nameLabel:
                    option.itemValue = ride.driverName
                case Labels.seatsLabel:
                    option.itemValue = String(ride.seats)
                case Labels.pickupRadius:
                    option.itemValue = ride.getRadius()
                case Labels.directionLabel:
                    option.itemValue = ride.getDirection()
                case Labels.phoneLabel:
                    option.itemValue = ride.driverNumber
                case Labels.departureTimeLabel:
                    option.itemValue = ride.getTime()
                case Labels.departureDateLabel:
                    option.itemValue = ride.getDate()
                case Labels.addressLabel:
                    option.itemValue = ride.getCompleteAddress()
            case Labels.passengers:
                    option.itemValue = String(ride.passengers.count)
                default:
                    print("")
            }
        }
        self.table?.reloadData()
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
        
        if(cell?.contentType.text == Labels.departureTimeLabel){
            timeValue = cell?.contentValue
        }
        else if(cell?.contentType.text == Labels.departureDateLabel){
            dateValue = cell?.contentValue
        }
        else if(cell?.contentType.text == Labels.seatsLabel){
            cell?.contentTextField.keyboardType = .NumberPad
            cell?.contentTextField.tag = EditTags.Seats.rawValue
            cell?.contentTextField.delegate = self
            seatsValue = cell?.contentTextField
        }
        else if(cell?.contentType.text == Labels.addressLabel){
            addressValue = cell?.contentValue
        }
        else if(cell?.contentType.text == Labels.nameLabel){
            nameValue = cell?.contentTextField
            cell?.contentTextField.tag = EditTags.Name.rawValue
            nameValue.delegate = self
        }
        else if(cell?.contentType.text == Labels.phoneLabel){
            cell?.contentTextField.keyboardType = .NumberPad
            cell?.contentTextField.tag = EditTags.Number.rawValue
            numberValue = cell?.contentTextField
            numberValue.delegate = self
            numberValue.text = PhoneFormatter.unparsePhoneNumber(ride.driverNumber)
        }
        else if(cell?.contentType.text == Labels.directionLabel){
            directionValue = cell?.contentValue
            directionCell = cell
            directionCellPath = indexPath
        }
        else if(cell?.contentType.text == Labels.pickupRadius){
            pickupRadius = cell?.contentTextField
            pickupRadius.tag = EditTags.Radius.rawValue
            pickupRadius.delegate = self
        }
        else if(cell?.contentType.text == Labels.passengers){
            passengerValue = cell?.contentTextField
        }
        
        cell?.editButton.hidden = !(option.itemEditable)
        table = tableView
    
        return cell!
    }

    @IBAction func editPressed(sender: UIButton) {
        let editChoice = sender.currentTitle
        hasUserEdited = true
        
        switch editChoice!{
            
            case Labels.departureTimeLabel:
                TimePicker.pickTime(self)
            case Labels.departureDateLabel:
                TimePicker.pickDate(self, handler: chooseDateHandler)
            case Labels.addressLabel:
                choosePickupLocation(self)
            case Labels.nameLabel:
                nameValue.becomeFirstResponder()
            case Labels.phoneLabel:
                numberValue.becomeFirstResponder()
            case Labels.seatsLabel:
                seatsValue.becomeFirstResponder()
            case Labels.directionLabel:
                self.performSegueWithIdentifier("direction", sender: self)
            case Labels.pickupRadius:
                self.performSegueWithIdentifier("radius", sender: self)
            case Labels.passengers:
                self.performSegueWithIdentifier("editPassengerSegue", sender: self)
            default:
                print("k")
        }
        
    }

    
    func chooseDateHandler(month : Int, day : Int, year : Int){
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "MM d yyyy"
        
        //if date formatter returns nil return the current date/time
        if let date = dateFormatter.dateFromString(String(month) + " " + String(day) + " " + String(year)) {
            ride.date = date
            self.dateValue.text = ride.getDate()
            extractDateTimeFromView()
            updateOptions()
        }
    }
    
    func datePicked(obj: NSDate){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        timeValue.text = formatter.stringFromDate(obj)
        extractDateTimeFromView()
        updateOptions()
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
    
    func extractDateTimeFromView()->Bool{
        ride.eventStartDate = event.startNSDate
        ride.eventEndDate = event.endNSDate
    
        
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
        
        ride.date = GlobalUtils.dateFromString(ride.getTimeInServerFormat())
        
        if (ride.isValidTime() == ""){
            return true
        }
        else{
            showValidationError(ride.isValidTime())
            return false
        }
    }

    
    func extractLocationFromView()->Bool{
        if(location != nil){
            let map = location.getLocationAsDict(location)
            
            ride.clearAddress()
            
            
            if(map[LocationKeys.city] != nil){
                ride.city = map[LocationKeys.city] as! String
            }
            if(map[LocationKeys.state] != nil){
                ride.state = map[LocationKeys.state] as! String
            }
            if(map[LocationKeys.street1] != nil){
                ride.street = map[LocationKeys.street1] as! String
            }
            if(map[LocationKeys.country] != nil){
                ride.country = map[LocationKeys.country] as! String
            }
            if(map[LocationKeys.postcode] != nil){
                ride.postcode = map[LocationKeys.postcode] as! String
            }
            
            if(ride.isValidAddress() == ""){
                return true
            }
            else{
                showValidationError(ride.isValidAddress())
                return false
            }
            
        }
        return true
        
    }
    
    
    func extractNameFromView() -> Bool{
        if (nameValue != nil){
            let error  = ride.isValidName(nameValue.text)
            if(error != ""){
                showValidationError(error)
                addTextViewError(nameValue)
                return false
            }
            else{
                ride.driverName = nameValue.text!
                removeTextViewError(nameValue)
                return true
            }
        }
        return true
    }
    
    func extractNumberFromView()->Bool{
        if (numberValue != nil){
            let parsedNum = PhoneFormatter.parsePhoneNumber(numberValue.text!)
            let error  = ride.isValidPhoneNum(parsedNum)
            if(error != ""){
                showValidationError(error)
                addTextViewError(numberValue)
                return false
            }
            else{
                ride.driverNumber = parsedNum
                removeTextViewError(numberValue)
                return true
            }
            
        }
        return true
    }
    
    
    func extractDirectionFromView(){
        if(directionValue != nil){
             ride.direction = ride.getServerDirectionValue(directionValue.text!)
        }
    }
    
    func extractMilesFromView(){
        let index1 = pickupRadius.text?.startIndex.advancedBy(2)
        let numMiles = pickupRadius.text?.substringToIndex(index1!)
        let trimmedString = numMiles!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet()
        )
        ride.radius = Int(trimmedString)!
    }
    
    
    func extractNumSeats()->Bool{
        if (seatsValue != nil && seatsValue != ""){
            if let val = Int(seatsValue.text.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())){
                    if(val == 0){
                        showValidationError(ValidationErrors.badSeats)
                        return false
                    }
                    else{
                        ride.seats = val
                        return true
                    }
            }
            else{
                showValidationError(ValidationErrors.badSeats)
            }
        }
        
        if(seatsValue != ""){
            showValidationError(ValidationErrors.noSeats)
            return false
        }
        return true
    }
    
    
    
    
    @IBAction func savePressed(sender: AnyObject) {
        
        //extract seats, time, date, location, name, phone number (all if possible aka null checking)
        
        if(timeValue != nil){ ride.time = timeValue.text! }
        
        if(extractNumSeats() == false){return}
        //you must extract direction before time, time validation depends on direction of ride
        extractDirectionFromView()
        if(extractDateTimeFromView() == false){return}
        if(extractLocationFromView() == false){return}
        if (extractNameFromView() == false){return}
        if (extractNumberFromView() == false){return}
        
        
        
        //radius already extracted when set
        extractMilesFromView()
    
        let timeInServer = ride.getTimeInServerFormat()
        
        CruClients.getRideUtils().patchRide(ride.id, params: [RideKeys.passengers: ride.passengers, RideKeys.radius: ride.radius, RideKeys.driverName: ride.driverName, RideKeys.direction: ride.direction, RideKeys.driverNumber: ride.driverNumber, RideKeys.time : ride.getTimeInServerFormat(), RideKeys.seats: ride.seats, LocationKeys.loc: [LocationKeys.postcode: ride.postcode, LocationKeys.state : ride.state, LocationKeys.street1 : ride.street, LocationKeys.city: ride.city, LocationKeys.country: ride.country]], handler: handlePostResult)
    }
    
    
    func addTextViewError(textView: UITextView){
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func removeTextViewError(textView: UITextView){
        textView.layer.borderWidth = 0
    }
    
    func showValidationError(error: String){
        let alert = UIAlertController(title: error, message: "", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: {})
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
            self.table!.reloadData()
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
        ride.direction = ride.getServerDirectionValue(choice)
        directionOption.itemValue = choice
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
            popoverVC.preferredContentSize = CGSizeMake(self.view.frame.width - 30, 195)
            
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
        else if(segue.identifier == "editPassengerSegue"){
            let popoverVC = segue.destinationViewController
            popoverVC.preferredContentSize = CGSize(width: self.view.frame.width * 0.97, height: self.view.frame.height * 0.77)
            popoverVC.popoverPresentationController!.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), (passengerValue?.frame.origin.y)! - 50.0,0,0)
            
            let controller = popoverVC.popoverPresentationController
            
            if(controller != nil){
                controller?.delegate = self
            }
            
            
            if let vc = popoverVC as? PassengersViewController{
                vc.passengers = self.passengers
                vc.editable = true
                vc.parentEditVC = self
            }
        }
    }
    
    
    func setRadius(radius: Int){
        pickupRadius.text = String(radius) + " mi."
        
        ride.radius = radius
        updateOptions()
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
    
    func textViewDidEndEditing(textView: UITextView) {
        let senderId = textView.tag
        
        switch senderId{
            case EditTags.Name.rawValue:
                ride.driverName = nameValue.text
            case EditTags.Number.rawValue:
                ride.driverNumber = numberValue.text
            //case EditTags.Time.rawValue
            //case EditTags.Date.rawValue
            //case EditTags.Address.rawValue
            case EditTags.Radius.rawValue:
                extractMilesFromView()
            case EditTags.Direction.rawValue:
                ride.direction = ride.getServerDirectionValue(directionValue.text!)
            case EditTags.Seats.rawValue:
                if let val = Int(seatsValue.text.stringByTrimmingCharactersInSet(
                    NSCharacterSet.whitespaceAndNewlineCharacterSet())){
                    if (ride.numSeatsNeedToDrop(val) >= 1 && val > 0){
                        needToDropPassenger(val, numToDrop: ride.numSeatsNeedToDrop(val))
                    }
                    else{
                        ride.seats = val
                    }
                }
            default:
                print("Issue -1 on edit ride page")
        }
        updateOptions()
    }
    
    func needToDropPassenger(num : Int, numToDrop: Int){
        var message = "If you want to lower the number of offered seats to " +
            String(num) + ", you must drop " + String(numToDrop)
        
        if(numToDrop == 1){
            message += " passenger."
        }
        else{
            message += " passengers."
        }
        
        showValidationError(message)
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
