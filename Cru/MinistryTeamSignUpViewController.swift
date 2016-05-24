//
//  MinistryTeamSignUpViewController.swift
//  Cru
//
//  Created by Deniz Tumer on 5/19/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import SwiftValidator

class MinistryTeamSignUpViewController: UIViewController, ValidationDelegate {
    @IBOutlet weak var fullNameField: UITextField!
    @IBOutlet weak var phoneNoField: UITextField!
    @IBOutlet weak var nameError: UILabel!
    @IBOutlet weak var phoneNoError: UILabel!
    
    //constants: should move later to config file
    private let fullNameKey = "fullName"
    private let phoneNoKey = "phoneNo"

    var ministryTeamStorageManager: MapLocalStorageManager!
    var ministryTeam: MinistryTeam!
    let validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up storage managers for ministry teams and for storing/loading user information
        ministryTeamStorageManager = MapLocalStorageManager(key: Config.ministryTeamStorageKey)
        
        //set up validator to validate the fields
        validator.registerField(fullNameField, errorLabel: nameError, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(phoneNoField, errorLabel: phoneNoError, rules: [RequiredRule(), PhoneNumberRule()])
        nameError.text = ""
        phoneNoError.text = ""
        
        //check if user is already in local storage
        if let user = ministryTeamStorageManager.getObject(Config.userStorageKey) as? NSDictionary {
            print(user)
            fullNameField.text = (user[fullNameKey] as! String)
            phoneNoField.text = (user[phoneNoKey] as! String)
        }
    }
    
    //action for submitting information from the sign up process
    @IBAction func submitInformation(sender: UIButton) {
        validator.validate(self)
    }
    
    //function to call if the validation is successful
    func validationSuccessful() {
        var user: Dictionary<String, String>! = [:]
        
        user[fullNameKey] = fullNameField.text
        user[phoneNoKey] = phoneNoField.text
        
        //update the user information in the local storage
        updateUserInformation(user)
        
        //add ministry team to list of ministry teams we're a part of
        ministryTeamStorageManager.addElement(ministryTeam.id, elem: ministryTeam.toDictionary())

        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKindOfClass(GetInvolvedViewController) {
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }
    }
    
    func updateUserInformation(user: NSDictionary) {
        let storedUser = ministryTeamStorageManager.getObject(Config.userStorageKey)
        
        //if there is no information stored about the user yet
        if storedUser == nil {
            print("ADDED NEW USER")
            ministryTeamStorageManager.putObject(Config.userStorageKey, object: user)
        }
        //if the information about the user is different in this form
        else {
            if let tempStore = storedUser as? NSDictionary {
                let storedFullName = tempStore[fullNameKey] as! String
                let storedPhoneNo = tempStore[phoneNoKey] as! String
                let fullName = user[fullNameKey] as! String
                let phoneNo = user[phoneNoKey] as! String
                
                if (storedFullName != fullName) || (storedPhoneNo != phoneNo) {
                    print("REPLACE EXISTING USER")
                    ministryTeamStorageManager.putObject(Config.userStorageKey, object: user)
                }
            }
        }
    }
    
    //function to call if the validation is not successful
    func validationFailed(errors: [UITextField : ValidationError]) {
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }
}
