//
//  EditRideViewController.swift
//  Cru
//
//  Created by Max Crane on 5/3/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EditRideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var event : Event!
    var ride : Ride!
    var options = [EditableItem]()
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var driverName: UITextField!
    @IBOutlet weak var driverNumber: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //not sure of what the effect of sizeToFit is really...
        //address.sizeToFit()
        
        populateLabels()
        
        options.append(EditableItem(itemName: "Event:", itemValue: event.name, itemEditable: false, itemIsText: false))
        options.append(EditableItem(itemName: "Departure Time:", itemValue: ride.time, itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: "Departure Date:", itemValue: ride.getTime(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: "Departure Address:", itemValue: ride.getCompleteAddress(), itemEditable: true, itemIsText: false))
        options.append(EditableItem(itemName: "Number of Seats:", itemValue: String(ride.seats), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: "Name:", itemValue: String(ride.driverName), itemEditable: true, itemIsText: true))
        options.append(EditableItem(itemName: "Phone Number:", itemValue: String(ride.driverNumber), itemEditable: true, itemIsText: true))
        
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
        
        if option.itemIsText! {
            cell?.contentValue.hidden = true
            cell?.contentTextField.hidden = false
            cell?.contentTextField.text = option.itemValue
        }
        else{
            cell?.contentTextField.hidden = true
            cell?.contentValue.hidden = false
        }
        
        
        cell?.editButton.hidden = !(option.itemEditable)
        
    
        return cell!
    }

    @IBAction func editPressed(sender: UIButton) {
        /*
        var editChoice = sender.titleLabel!.text
        
        switch editChoice!{
            case "editTime":
                TimePicker.pickTime(self)
            case "editDate":
                TimePicker.pickDate(self, handler: chooseDateHandler)
            case "editAddress":
                print("editAddress")
            case "editName":
                driverName.becomeFirstResponder()
            case "editNumber":
                driverNumber.becomeFirstResponder()
            default:
                print("k")
        }
        */
    }
    
    func chooseDateHandler(month : Int, day : Int, year : Int){
        let month = String(month)
        let day = String(day)
        let year = String(year)
        
        self.dateLabel.text = month + "/" + day + "/" + year
    }
    
    func datePicked(obj: NSDate){
        if let val = obj as? NSDate{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "h:mm a"
            timeLabel.text = formatter.stringFromDate(val)
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
