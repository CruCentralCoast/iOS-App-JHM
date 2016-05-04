//
//  EditRideViewController.swift
//  Cru
//
//  Created by Max Crane on 5/3/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class EditRideViewController: UIViewController {
    var event : Event!
    var ride : Ride!
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
    }
    
    
    func populateLabels(){
        eventName.text = event!.name
        address.text = ride!.getCompleteAddress()
        driverName.text = ride!.driverName
        driverNumber.text = ride!.driverNumber
        timeLabel.text = ride!.time
    }


    @IBAction func editPressed(sender: UIButton) {
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
