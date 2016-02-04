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
    @IBOutlet weak var rideDirectionLabel: UILabel!
    
    @IBOutlet weak var rideTime: UILabel!
    @IBOutlet weak var rideDate: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var rideDirectionIcon: UIImageView!
    @IBOutlet weak var rideTypeLabel: UILabel!
    @IBOutlet weak var rideTypeIcon: UIImageView!
    
    @IBOutlet weak var driverName: UILabel!
    
    @IBOutlet weak var numSeatLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventName.text = event!.name
        driverName.text = ride!.driverName + " is driving"
        numSeatLabel.text = "1/" + ride!.seats + " seats are available"
        
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
