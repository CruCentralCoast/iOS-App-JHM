//
//  JoinRideViewController.swift
//  Cru
//
//  Created by Max Crane on 2/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import MapKit
import SwiftValidator
import FlatUIKit

class JoinRideViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {

    @IBOutlet weak var join: FUIButton!
    @IBOutlet weak var time: UILabel!
  
    @IBOutlet weak var address: UITextView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var number: UITextField!
    
    @IBOutlet weak var numberError: UILabel!
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var rideDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var seats: UILabel!
    @IBOutlet weak var date: UILabel!
    let validator = Validator()
    
    var ride: Ride?
    var event: Event?
    
    let dummyAddress = "1 Grand Avenue San Luis Obispo 93401 California"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Join Ride"
        ServerUtils.findEventById(ride!.eventId, inserter: insertEvent)
        
        print("trying to load ride")
        if(ride != nil){
            print("ride was loadede")
            rideDate.text = ride?.getDate()
            time.text = ride?.getTime()
            seats.text = (ride?.seatsLeft())! + " left"
            address.text = dummyAddress
            
        }
        else{
            date.text = ""
            time.text = ""
            seats.text = ""
            address.text = ""
        }
        
        number.keyboardType = .NumberPad
        nameError.text = ""
        numberError.text = ""
        
        makeButtonPretty()
        validator.registerField(name, errorLabel: nameError, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(number, errorLabel: numberError, rules: [RequiredRule(), PhoneNumberRule()])
        
        setupMap()
        //dateTimeLabel.text = ride?.getDescription()
        // Do any additional setup after loading the view.
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    func makeButtonPretty(){
        join.buttonColor = UIColor.turquoiseColor()
        join.shadowColor = UIColor.greenSeaColor()
        join.shadowHeight = 3.0
        join.cornerRadius = 6.0
        join.titleLabel!.font = UIFont.boldFlatFontOfSize(16)
        join.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Normal)
        join.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Highlighted)
        
    }
    
    func insertEvent(dict: NSDictionary){
        let event = Event(dict: dict)
        eventName.text = event!.name
        eventTime.text = String(event!.startHour)
//        if(event!.startDay != nil){
//        date.text = String(event!.startDay)
//        }
//        else{
//           date.text = "mondee"
//        }
    }
    
    func validationSuccessful() {
        // submit the form
        let phoneNumber = number.text
        let nameString = name.text
    }
    
    func validationFailed(errors:[UITextField:ValidationError]) {
        var numValid = true
        var nameValid = true
        
        // turn the fields to red
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
            
            if(field == name){
                nameValid = false
            }
            if(field == number){
                numValid = false
            }
        }
        
        if(nameValid){
            name.layer.borderColor = UIColor.clearColor().CGColor
            name.layer.borderWidth = 0.0
            nameError.text = ""
        }
        if(numValid){
            number.layer.borderColor = UIColor.clearColor().CGColor
            number.layer.borderWidth = 0.0
            numberError.text = ""
        }
    }

    
    @IBAction func joinRidePressed(sender: AnyObject) {
        validator.validate(self)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
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
