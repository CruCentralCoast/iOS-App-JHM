//
//  DriverRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class DriverRideDetailViewController: UIViewController {
    var event: Event!
    var ride: Ride!
    
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var rideName: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var passengerList: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rideName.text = event!.name!
        // Do any additional setup after loading the view.
        
        print("\nNumber of seats = ")
        print(ride.seats);
        
        //Change the image depending on the number of passengers
        if(ride.passengers.count == 0){
            carImage.image = UIImage(named: "car-empty")
            passengerList.text = "Currently there are no passengers in your car"
        }
        else if(ride.passengers.count == 1){
            carImage.image = UIImage(named: "car-1")
            
        }
        else if(ride.passengers.count == 2){
            carImage.image = UIImage(named: "car-2")
        }
        else if(ride.passengers.count == 3){
            carImage.image = UIImage(named: "car-3")
        }
        else if(ride.passengers.count == 4){
            carImage.image = UIImage(named: "car-4")
        }
        else if(ride.passengers.count == 5){
            carImage.image = UIImage(named: "car-5")
        }
        else {
            carImage.image = UIImage(named: "car-full")
        }
        
        departureTime.text = ride.time
        
        // Append the passengers' names and phone numbers to the passenger list
        if(ride.passengers.count > 0) {
            passengerList.text = ""
            for item in ride.passengers {
                passengerList.text = passengerList.text + ride.passengers + "\n"
                
            }
        }
        
        
        
        
    }
    
    func injectPassenger() {
        
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
