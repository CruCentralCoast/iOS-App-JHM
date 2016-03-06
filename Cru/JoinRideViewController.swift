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
import MRProgress

struct JoinRideConstants{
    static let NAME = "Join Ride"
    static let ROUND_TRIP = "Both"
    static let TO_EVENT = "To"
    static let FROM_EVENT = "From"
    static let DIR_ROUND_TRIP = "Round Trip"
    static let DIR_TO = "To Event"
    static let DIR_FROM = "From Event"
}

class JoinRideViewController: UIViewController, UITextFieldDelegate, ValidationDelegate {
    //Buttons, labels, a map
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
    @IBOutlet weak var tripType: UILabel!
    
    //for validating user input
    let validator = Validator()
    
    //sources of data to be displayed
    var ride: Ride?
    var event: Event?
    let dummyAddress = "1 Grand Avenue San Luis Obispo 93401 California"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.title = JoinRideConstants.NAME
        setupMap()
        

        
        if(ride != nil){
            rideDate.text = ride?.getDate()
            time.text = ride?.getTime()
            seats.text = (ride?.seatsLeft())! + " left"
            address.text = ride!.getCompleteAddress()
            
            print(ride!.direction)
            if(ride!.direction.caseInsensitiveCompare(JoinRideConstants.ROUND_TRIP) == NSComparisonResult.OrderedSame){
                tripType.text = JoinRideConstants.DIR_ROUND_TRIP
            }
            else if(ride!.direction.caseInsensitiveCompare(JoinRideConstants.TO_EVENT) == NSComparisonResult.OrderedSame){
                tripType.text = JoinRideConstants.DIR_TO
            }
            else if(ride!.direction.caseInsensitiveCompare(JoinRideConstants.FROM_EVENT) == NSComparisonResult.OrderedSame){
                tripType.text = JoinRideConstants.DIR_FROM
            }
        }
        else{
            rideDate.text = ""
            time.text = ""
            seats.text = ""
            address.text = ""
        }
        
        if(event != nil){
            eventName.text = event!.name
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            
            let months = dateFormatter.shortMonthSymbols
            let monthShort = months[event!.startDateMonth-1]
            
            eventDate.text =  monthShort.lowercaseString +  "/" + String(event!.startDateDay)
            eventTime.text = Ride.createTime(event!.startDateHour, minute: event!.startDateMinute)
        }
        
        number.keyboardType = .NumberPad
        nameError.text = ""
        numberError.text = ""
        
        //initalize validation things
        makeButtonPretty()
        validator.registerField(name, errorLabel: nameError, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(number, errorLabel: numberError, rules: [RequiredRule(), PhoneNumberRule()])

        
    }

    @IBAction func dismissKeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    
    func makeButtonPretty(){
        join.buttonColor = Colors.green
        join.shadowColor = Colors.darkerGreen
        join.shadowHeight = 3.0
        join.cornerRadius = 6.0
        join.titleLabel!.font = UIFont.boldFlatFontOfSize(16)
        join.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Normal)
        join.setTitleColor(UIColor.cloudsColor(), forState: UIControlState.Highlighted)
        
    }
    
    func insertEvent(dict: NSDictionary){
        let event = Event(dict: dict)
        eventName.text = event!.name
        eventDate.text = "3/11/16"
        eventTime.text = String(event!.startDateHour)
    }
    
    func validationSuccessful() {
        
        // submit the form
        let phoneNumber = number.text
        let nameString = name.text
        
        resetLabel(name, error: nameError)
        resetLabel(number, error: numberError)
        
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        RideUtils.joinRide(nameString!, phone: phoneNumber!, direction: "both",  rideId: (ride?.id)!, handler: successfulJoin)
        
    }
    
    func successfulJoin(){
        let success = UIAlertController(title: "Join Successful", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        success.addAction(UIAlertAction(title: "Ok", style: .Default, handler: unwindToRideList))

        MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
        self.presentViewController(success, animated: true, completion: nil)
        
        
    }
    
    func unwindToRideList(action: UIAlertAction){
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
            //navController.popViewControllerAnimated(true)
            
            for vc in navController.viewControllers{
                if let tvc = vc as? RidesTableViewController {
                    tvc.refresh(1)
                }
            }
        }
    }
    
    func resetLabel(field: UITextField, error: UILabel){
        field.layer.borderColor = UIColor.clearColor().CGColor
        field.layer.borderWidth = 0.0
        error.text = ""
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
            resetLabel(name, error: nameError)
        }
        if(numValid){
            resetLabel(number, error: numberError)
        }
    }

    
    @IBAction func joinRidePressed(sender: AnyObject) {
        self.view.endEditing(true)
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
            request.naturalLanguageQuery = ride!.getCompleteAddress()
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
