//
//  RiderRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class RiderRideDetailViewController: UIViewController {
    var event: Event?
    var ride: Ride?
    
    
    @IBOutlet weak var eventTitle: UILabel!
    
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var departureMonth: UILabel!
    @IBOutlet weak var departureDay: UILabel!
    @IBOutlet weak var pickupAddress: UILabel!
    
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var directionIcon: UIImageView!
    
    @IBOutlet weak var driverName: UILabel!
    
    @IBOutlet weak var driverNumber: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ride Details"
        
        eventTitle.text = event!.name
        departureTime.text = ride!.time
        departureMonth.text = String(ride!.month)
        departureDay.text = String(ride!.day)
        
        pickupAddress.sizeToFit()
        
        //pickupAddress =
        //direction = 
        //directionIcon
        driverName.text = ride!.driverName
        
        driverNumber.text = ride!.driverNumber
        driverNumber.editable = false
        driverNumber.dataDetectorTypes = UIDataDetectorTypes.PhoneNumber
        
//        eventName.text = event!.name
//        driverName.text = ride!.driverName + " is driving"
//        numSeatLabel.text = "1/5 seats"  //ride!.seats + " seats are available"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
