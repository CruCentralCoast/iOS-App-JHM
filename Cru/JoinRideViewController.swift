//
//  JoinRideViewController.swift
//  Cru
//
//  Created by Max Crane on 2/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MapKit

class JoinRideViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    
    
    var ride: Ride?
    let dummyAddress = "1 Grand Ave. San Luis Obispo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("trying to load ride")
        if(ride != nil){
            print("ride was loadede")
            details.text = ride?.getDescription()
            address.text = dummyAddress
            
        }
        else{
            details.text = ""
        }
        
        number.keyboardType = .NumberPad
//        self.number.delegate = self
//        self.name.delegate = self
        
        setupMap()
        //dateTimeLabel.text = ride?.getDescription()
        // Do any additional setup after loading the view.
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }

    
    @IBAction func joinRidePressed(sender: AnyObject) {
        let phoneNumber = number.text
        let nameString = name.text
        
        print("\(validate(phoneNumber!))")
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func validate(value: String) -> Bool {
        
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        
        var phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        

        var result =  phoneTest.evaluateWithObject(value)
        
        return result
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMap(){
        
        var initialLocation = CLLocation()
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = dummyAddress
        
        if(request.naturalLanguageQuery != nil){
            request.naturalLanguageQuery = self.address.text
        }
        
        request.region = map.region
        
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
                self.map.addAnnotation(dropPin)
            }
        }
    }
    
    
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        map.setRegion(coordinateRegion, animated: true)
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
