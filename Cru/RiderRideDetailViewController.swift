//
//  RiderRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MapKit

class RiderRideDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let roundTrip = "round-trip"
    let roundTripDirection = "both"
    let fromEvent = "from event"
    let toEvent = "to event"
    let driver = "driver"
    let rider = "rider"
    
    var details = [EditableItem]()
    var event: Event!
    var ride: Ride?
    var rideVC: RidesViewController?

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func populateDetails(){
        details.append(EditableItem(itemName: Labels.driverName, itemValue: (ride?.driverName)!, itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: Labels.driverNumber, itemValue: (ride?.driverNumber)!, itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: Labels.addressLabel, itemValue: (ride?.getCompleteAddress())!, itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: Labels.departureDateLabel, itemValue: (ride?.getDate())!, itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: Labels.departureTimeLabel, itemValue: (ride?.getTime())!, itemEditable: false, itemIsText: true))
        details.append(EditableItem(itemName: Labels.directionLabel, itemValue: (ride?.getDirection())!, itemEditable: false, itemIsText: true))
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! DetailCell
        
        if(details[indexPath.row].itemName == Labels.driverNumber){
            cell.textViewValue.text = PhoneFormatter.unparsePhoneNumber(details[indexPath.row].itemValue)
            cell.textViewValue.dataDetectorTypes = .PhoneNumber
            cell.title.text = details[indexPath.row].itemName
            cell.textViewValue.hidden = false
            cell.value.hidden = true
        }
        else if(details[indexPath.row].itemName == Labels.addressLabel){
            cell.textViewValue.text = details[indexPath.row].itemValue
            cell.textViewValue.dataDetectorTypes = .Address
            cell.title.text = details[indexPath.row].itemName
            cell.textViewValue.hidden = false
            cell.value.hidden = true
        }
        else{
            cell.value.text = details[indexPath.row].itemValue
            cell.title.text = details[indexPath.row].itemName
            cell.textViewValue.hidden = true
            cell.value.hidden = false
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Ride Details"
        populateDetails()

    }
    
    func setTime(td : TimeDetail){
        //date.text = td.getTime()
    }
    
    @IBAction func eventLabelPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("eventDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "eventDetailSegue"){
            let vc = segue.destinationViewController as! EventDetailsViewController
            vc.event = self.event
        }
    }
    
    func setupMap(){
        
        var initialLocation = CLLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = ride!.getCompleteAddress()
        
        if(request.naturalLanguageQuery != nil){
            //request.naturalLanguageQuery = self.address.text
        }
        
        //request.region = pickupMap.region
        
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response, error) in
            guard let response = response else {
                print("Search error: \(error)")
                return
            }
            
            for item in response.mapItems {
                initialLocation = item.placemark.location!
                let dropPin = MKPointAnnotation()
                dropPin.coordinate = initialLocation.coordinate
                //dropPin.title = self.address.text
                
                
                self.centerMapOnLocation(initialLocation)
                //self.pickupMap.addAnnotation(dropPin)
            }
        }
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        //let regionRadius: CLLocationDistance = 1000
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
           // regionRadius * 2.0, regionRadius * 2.0)
        //pickupMap.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        Cancler.confirmCancel(self, handler: cancelConfirmed)
    }
    
    func cancelConfirmed(action: UIAlertAction){
        CruClients.getRideUtils().leaveRidePassenger(ride!, handler: { success in
            if let navController = self.navigationController {
                navController.popViewControllerAnimated(true)
                self.rideVC?.refresh(self)
            }
        })
    }
    
    func leaveRide(passid: String, rideid: String){
        
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
