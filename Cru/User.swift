//
//  User.swift
//  Cru
//
//  Created by Deniz Tumer on 11/29/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    //MARK: Properties
    var firstName: String
    var lastName: String
    var phoneNo: String
    struct PropertyKey {
        static let firstNameKey = "firstName"
        static let lastNameKey = "lastName"
        static let phoneNoKey = "PhoneNo"
    }
    
    //MARK: Initialization
    init?(first: String, last:String, phone: String) {
        self.firstName = first
        self.lastName = last
        self.phoneNo = phone
        super.init()
    
        //check initialization of object properties and return nil if one is not set
        if first.isEmpty || last.isEmpty || phone.isEmpty {
            return nil
        }
    }
    
    
    //MARK: NSCoding
    
    //function for encoding the given object into an NSObject for storing in the local drive
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(firstName, forKey: PropertyKey.firstNameKey)
        aCoder.encodeObject(lastName, forKey: PropertyKey.lastNameKey)
        aCoder.encodeObject(phoneNo, forKey: PropertyKey.phoneNoKey)
    }
    
    //function for initializing the NSCoding object for converting this class to an NSObject for storage
    required convenience init?(coder aDecoder: NSCoder) {
        //grab all object properties and downcast as appropriately
        let firstName = aDecoder.decodeObjectForKey(PropertyKey.firstNameKey) as! String
        let lastName = aDecoder.decodeObjectForKey(PropertyKey.lastNameKey) as! String
        let phoneNo = aDecoder.decodeObjectForKey(PropertyKey.phoneNoKey) as! String
        
        //call initializer on object
        self.init(first: firstName, last: lastName, phone: phoneNo)
    }
}
