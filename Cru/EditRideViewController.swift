//
//  EditRideViewController.swift
//  Cru
//
//  Created by Max Crane on 5/3/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //not sure of what the effect of sizeToFit is really...
        //address.sizeToFit()
        
        populateLabels()
        
        options.append(EditableItem(itemName: eventLabel, itemValue: event.name, itemEditable: false, itemIsText: false))
        options.append(EditableItem(itemName: departureTimeLabel, itemValue: ride.getTime(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: departureDateLabel, itemValue: ride.getDate(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: addressLabel, itemValue: ride.getCompleteAddress(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: seatsLabel, itemValue: String(ride.seats), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: nameLabel, itemValue: String(ride.driverName), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: phoneLabel, itemValue: String(ride.driverNumber), itemEditable: true, itemIsText: true))
        
        //print("number is \(ride.driverNumber)")
        
    }
    
    
    
    func populateLabels(){
        //eventName.text = event!.name
        //address.text = ride!.getCompleteAddress()
        //driverName.text = ride!.driverName
        //driverNumber.text = ride!.driverNumber
        //timeLabel.text = ride!.time
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
            //something
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
        
        
        switch editChoice!{
            case departureTimeLabel:
                TimePicker.pickTime(self)
            case departureDateLabel:
                TimePicker.pickDate(self, handler: chooseDateHandler)
            case addressLabel:
                print("editAddress")
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
        let month = String(month)
        let day = String(day)
        let year = String(year)
        
        self.dateValue.text = month + "/" + day + "/" + year
    }
    
    func datePicked(obj: NSDate){
        if let val = obj as? NSDate{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "h:mm a"
            timeValue.text = formatter.stringFromDate(val)
        }
    }
    

    @IBAction func savePressed(sender: AnyObject) {
        
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
