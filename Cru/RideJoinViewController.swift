//
//  RideJoinViewController.swift
//  Cru
//
//  Created by Max Crane on 5/29/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MRProgress

struct JoinRideConstants{
    static let NAME = "Join Ride"
    static let ROUND_TRIP = "Both"
    static let TO_EVENT = "To"
    static let FROM_EVENT = "From"
    static let DIR_ROUND_TRIP = "Round Trip"
    static let DIR_TO = "To Event"
    static let DIR_FROM = "From Event"
    static let DETAIL_CELL = "detailCell"
    static let EDIT_CELL = "editCell"
}

class RideJoinViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    //sources of data to be displayed
    var ride: Ride!
    var event: Event!
    var rideVC:RidesViewController!
    var tableCells = [UITableViewCell]()
    @IBOutlet weak var table: UITableView!
    var numberValue : UITextView!
    var nameValue : UITextView!
    
    var parsedName = ""
    var parsedNum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = JoinRideConstants.NAME
        table.dataSource = self
        table.delegate = self
        
        createCells()
        
        table.estimatedRowHeight = 50.0
        table.rowHeight = UITableViewAutomaticDimension
    }

    func createCells(){
        let nameCell = table.dequeueReusableCellWithIdentifier("editCell") as! RiderEditTableViewCell
        nameCell.title.text = Labels.nameLabel
        nameCell.value.text = ""
        tableCells.append(nameCell)
        
        let phoneCell = table.dequeueReusableCellWithIdentifier("editCell") as! RiderEditTableViewCell
        phoneCell.title.text = Labels.phoneLabel
        phoneCell.value.text = ""
        tableCells.append(phoneCell)
        
        let departureA = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        departureA.cellLabel.text = Labels.addressLabel
        departureA.value.text = ride.getCompleteAddress()
        tableCells.append(departureA)
        
        let departureT = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        departureT.cellLabel.text = Labels.departureTimeLabel
        departureT.value.text = ride.getTime()
        tableCells.append(departureT)
        
        let departureD = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        departureD.cellLabel.text = Labels.departureDateLabel
        departureD.value.text = ride.getDate()
        tableCells.append(departureD)
        
        let eventName = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        eventName.cellLabel.text = Labels.eventLabel
        eventName.value.text = event.name
        tableCells.append(eventName)
        
        let eventDate = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        eventDate.cellLabel.text = Labels.eventAddressLabel
        eventDate.value.text = event.getTime()
        tableCells.append(eventDate)
        
        let eventA = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        eventA.cellLabel.text = Labels.eventAddressLabel
        eventA.value.text = event.getLocationString()
        tableCells.append(eventA)

        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableCells[indexPath.row] as? DriverDetailCell{
            if let rCell = tableView.dequeueReusableCellWithIdentifier(JoinRideConstants.DETAIL_CELL) as? DriverDetailCell{
                rCell.cellLabel.text = cell.cellLabel.text
                rCell.value.text = cell.value.text
                return rCell
            }
        }
        
        if let cell = tableCells[indexPath.row] as? RiderEditTableViewCell{
            if let rCell = tableView.dequeueReusableCellWithIdentifier(JoinRideConstants.EDIT_CELL) as? RiderEditTableViewCell{
                
                rCell.title.text = cell.title.text
                rCell.value.text = cell.value.text
                
                if(cell.title.text == Labels.phoneLabel){
                    numberValue = rCell.value
                    rCell.value.keyboardType = .NumberPad
                    rCell.value.delegate = self
                }else if(cell.title.text == Labels.nameLabel){
                    nameValue = rCell.value
                    rCell.value.delegate = self
                }
                
                return rCell
            }
        }
        let emptyCell = table.dequeueReusableCellWithIdentifier("detailCell") as! DriverDetailCell
        return emptyCell
    }

    @IBAction func submitPressed(sender: AnyObject) {
        if(extractNameFromView() == false){return}
        if(extractNumberFromView() == false){return}
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        CruClients.getRideUtils().joinRide(parsedName, phone: parsedNum, direction: ride.direction,  rideId: ride.id, handler: successfulJoin)
        
    }
    
    func successfulJoin(success: Bool){
        var msg: String
        if success {
            msg = "Join Successful"
        } else {
            msg = "Failed to Join Ride"
        }
        
        let successAlert = UIAlertController(title: msg, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: unwindToRideList))
        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        
        if (success == true){
            self.presentViewController(successAlert, animated: true, completion: nil)
        }
        
    }
    
    func unwindToRideList(action: UIAlertAction){
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
            navController.popViewControllerAnimated(true)
            
            if (rideVC != nil){
                rideVC?.refresh(self)
            }
            
        }
    }
    
    func extractNumberFromView()->Bool{
        if (numberValue != nil){
            parsedNum = PhoneFormatter.parsePhoneNumber(numberValue.text!)
            
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
    
    func extractNameFromView() -> Bool{
        if (nameValue != nil){
            let error  = ride.isValidName(nameValue.text)
            if(error != ""){
                showValidationError(error)
                addTextViewError(nameValue)
                return false
            }
            else{
                parsedName = nameValue.text!
                ride.driverName = nameValue.text!
                removeTextViewError(nameValue)
                return true
            }
        }
        return true
    }
    
    func showValidationError(error: String){
        let alert = UIAlertController(title: error, message: "", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: {})
    }
    
    func addTextViewError(textView: UITextView){
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.redColor().CGColor
    }
    
    func removeTextViewError(textView: UITextView){
        textView.layer.borderWidth = 0
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(textView == nameValue){
            let currentCharacterCount = textView.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + text.characters.count - range.length
            return newLength <= 50
        }
        else if numberValue != nil {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new viewtroller.
    }
    */

}
