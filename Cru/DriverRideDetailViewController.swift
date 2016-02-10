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
    
    @IBOutlet weak var rideName: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rideName.text = event!.name!
        // Do any additional setup after loading the view.
        
        //Change the image depending on the number of passengers
        if(Int(ride.seats) == 2){
            carImage.image = UIImage(named: "car-2")
        }
        else if(Int(ride.seats) == 3){
            carImage.image = UIImage(named: "car-3")
        }
        else if(Int(ride.seats) == 4){
            carImage.image = UIImage(named: "car-4")
        }
        else if(Int(ride.seats) == 4){
            carImage.image = UIImage(named: "car-5")
        }
        else {
            carImage.image = UIImage(named: "car-full")
        }
        
        
        
        
        
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
