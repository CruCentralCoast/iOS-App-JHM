//
//  Passenger.swift
//  Cru
//
//  Created by Max Crane on 2/23/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Passenger {
    var name = ""
    var phone = ""
    var direction = ""
    
    init(dict: NSDictionary){
        if (dict.objectForKey("name") != nil){
            name = dict.objectForKey("name") as! String
        }
        if (dict.objectForKey("phone") != nil){
            phone = dict.objectForKey("phone") as! String
        }
        if (dict.objectForKey("direction") != nil){
            direction = dict.objectForKey("direction") as! String
        }
    }
    
}