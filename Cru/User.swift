//
//  User.swift
//  Cru
//
//  Created by Deniz Tumer on 11/29/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class User {

    let name: String!
    let phone: String!
    let email: String!
    
    init(dict: NSDictionary) {
        name = dict["name"] as! String
        phone = dict["phone"] as! String
        email = dict["email"] as! String
    }
}
