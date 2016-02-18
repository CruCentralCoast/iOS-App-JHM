//
//  DriverRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class DriverRideDetailViewController: UIViewController, UITableViewDelegate {
    
    //MARK: Properties
    var event: Event!
    var ride: Ride!
    var passengers = [String]()
    

    @IBOutlet weak var departureDate: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var departureLoc: UITextView!
    @IBOutlet weak var rideName: UILabel!
    @IBOutlet weak var passengerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Declare the delegate
        self.passengerTable.delegate = self
        passengerTable.scrollEnabled = false;
        
        
        //Set the ride name
        rideName.text = event!.name!
        
        passengers += ["Erica Solum", "Max Crane", "Pete Godkin", "Deniz Tumer", "Quan Tran"]
        
        //Change the image depending on the number of passengers
        /*if(ride.passengers.count == 0){
            carImage.image = UIImage(named: "car-empty")
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
        }*/
        
        departureTime.text = ride.time
        departureDate.text = String("\(ride.month) \(ride.day)")
        departureLoc.text = String("1 Grand Avenue, San Luis Obispo, CA 93410")
        
        passengerTable.backgroundColor = UIColor.clearColor()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // UITableView functions for the passenger list
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passengers.count
    }
    //Set up the cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "PassengerTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PassengerTableViewCell
        
        cell.nameLabel!.text = passengers[indexPath.row]
        if(ride.direction == "to event") {
            cell.tripIndicator!.image = UIImage(named: "toEvent")
        }
        else if(ride.direction == "from event") {
            cell.tripIndicator!.image = UIImage(named: "fromEvent")
        }
        else {
            cell.tripIndicator!.image = UIImage(named: "roundTrip")
        }
        
        
        if(indexPath.row % 4 == 0) {
            cell.nameLabel.textColor = CruColors.darkBlue
            cell.phoneLabel.textColor = CruColors.darkBlue
        }
        else if(indexPath.row % 4 == 1) {
            cell.nameLabel.textColor = CruColors.lightBlue
            cell.phoneLabel.textColor = CruColors.lightBlue
        }
        else if(indexPath.row % 4 == 2) {
            cell.nameLabel.textColor = CruColors.yellow
            cell.phoneLabel.textColor = CruColors.yellow
        }
        else if(indexPath.row % 4 == 3) {
            cell.nameLabel.textColor = CruColors.orange
            cell.phoneLabel.textColor = CruColors.orange
        }
        return cell
    }
    
    // Reload the data every time we come back to this view controller
    override func viewDidAppear(animated: Bool) {
        passengerTable.reloadData()
        self.navigationItem.title = "Ride Details"
    }
    
    // MARK: - Navigation
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
        
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
