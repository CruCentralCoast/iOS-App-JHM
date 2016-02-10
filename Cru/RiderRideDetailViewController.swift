//
//  RiderRideDetailViewController.swift
//  Cru
//
//  Created by Max Crane on 2/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MapKit

class RiderRideDetailViewController: UIViewController {
    let roundTrip = "round-trip"
    let roundTripDirection = "both"
    let fromEvent = "from event"
    let toEvent = "to event"
    let driver = "driver"
    let rider = "rider"
    
    var event: Event?
    var ride: Ride?
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var direction: UILabel!
    @IBOutlet weak var directionIcon: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var date: UITextView!
    @IBOutlet weak var driverNumber: UITextView!
    @IBOutlet weak var pickupMap: MKMapView!
    @IBOutlet weak var address: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Ride Details"
        
        eventTitle.text = event!.name
        date.text = String(ride!.month) + "   " + String(ride!.day) + "   " + ride!.time
        
        //TODO: get address from ride 
        address.text = "1 Grand Ave. 93405 San Luis Obispo"
        //address.sizeToFit()

        setupMap()
        
        driverName.text = ride!.driverName
        driverNumber.text = ride!.driverNumber
        
        
        
        if(ride!.direction == roundTripDirection){
            directionIcon.image = UIImage(named: "twoway")
            direction.text = roundTrip
        }
        else if(ride!.direction == "from"){
            directionIcon.image = UIImage(named: "oneway")
            direction.text = fromEvent

            //mirrors arrow
            directionIcon.transform = CGAffineTransformMakeScale(-1, 1)
        }
        else if (ride!.direction == "to"){
            directionIcon.image = UIImage(named: "oneway")
            direction.text = toEvent
        }
        
    }
    
    func setupMap(){
        
        var initialLocation = CLLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.address.text//"1128 Peach San Luis Obispo"
        
        if(request.naturalLanguageQuery != nil){
            request.naturalLanguageQuery = self.address.text
        }
        
        request.region = pickupMap.region
        
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
                dropPin.title = self.address.text
                
                
                self.centerMapOnLocation(initialLocation)
                self.pickupMap.addAnnotation(dropPin)
            }
        }
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        pickupMap.setRegion(coordinateRegion, animated: true)
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
