//
//  OfferRideViewController.swift
//  Cru
//
//  Created by Max Crane on 4/14/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import RadioButton
import SwiftValidator

class OfferRideViewController: UIViewController, ValidationDelegate {
    @IBOutlet weak var numSeats: UILabel!
    @IBOutlet weak var roundTripButton: RadioButton!
    @IBOutlet weak var toEventButton: RadioButton!
    @IBOutlet weak var fromEventButton: RadioButton!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameFieldError: UILabel!
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneFieldError: UILabel!
    
    var checkImage = UIImage(named: "checked")
    var uncheckImage = UIImage(named: "unchecked")
    let validator = Validator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundTripButton.setImage(checkImage, forState: UIControlState.Selected)
        roundTripButton.setImage(uncheckImage, forState: UIControlState.Normal)
        
        toEventButton.setImage(checkImage, forState: UIControlState.Selected)
        toEventButton.setImage(uncheckImage, forState: UIControlState.Normal)
        
        fromEventButton.setImage(checkImage, forState: UIControlState.Selected)
        fromEventButton.setImage(uncheckImage, forState: UIControlState.Normal)
        
        stepper.value = 1
        
        validator.registerField(nameField, errorLabel: nameFieldError, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(phoneField, errorLabel: phoneFieldError, rules: [RequiredRule(), PhoneNumberRule()])
        
        nameFieldError.text = ""
        phoneFieldError.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numSeatsChanged(sender: UIStepper) {
        var val =  Int(sender.value).description

        if(val == "0"){
            val = "1"
            sender.value = 1
        }
        
        numSeats.text = val
        
    }

    
    @IBAction func touchedButton(sender: AnyObject) {
        if let sendr = sender as? RadioButton{
            let text = sendr.titleLabel?.text
            if(text == "  Round-Trip"){

            }
            else if(text == "  To Event"){

            }
            else if(text == "  From Event"){

            }
        }
    }
    
    
    func validationSuccessful() {
        
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
            
            if(field == nameField){
                nameValid = false
            }
            if(field == phoneField){
                numValid = false
            }
        }
        
        if(nameValid){
            resetLabel(nameField, error: nameFieldError)
        }
        if(numValid){
            resetLabel(phoneField, error: phoneFieldError)
        }
    }
    
    @IBAction func submitPressed(sender: UIButton) {
        validator.validate(self)
    }
    
    @IBAction func choosePickupLocation(sender: AnyObject) {
        print("choose loc")
    }
    
    @IBAction func chooseEventSelected(sender: AnyObject) {
        print("choose event")
    }
    

}
