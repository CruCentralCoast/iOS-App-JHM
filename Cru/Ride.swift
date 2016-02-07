//
//  Ride.swift
//  Cru
//
//  Created by Quan Tran on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Ride {
    var id: String
    var direction: String
    var seats: Int
    var radius: Int
    var gcmId: String
    var driverNumber: String
    var driverName: String
    var eventId: String
    var time: String
    var passengers: [String]
    var day = 3
    var month = 3
    var hour = 3
    var minute = 3
    
    
    
    init?(dict: NSDictionary){
        id = "blah"
        direction = "both"
        seats = 3
        radius = 1
        gcmId = "blah"
        driverNumber = "123456789"
        driverName = "Max crane"
        eventId = "3432432414"
        time = "5:00"
        passengers = [String]()
        
        if (dict.objectForKey("_id") != nil){
            id = dict.objectForKey("_id") as! String
        }
        if (dict.objectForKey("direction") != nil){
            direction = dict.objectForKey("direction") as! String
        }
        if (dict.objectForKey("seats") != nil){
            seats = dict.objectForKey("seats") as! Int
        }
        if (dict.objectForKey("radius") != nil){
            radius = dict.objectForKey("radius") as! Int
        }
        if (dict.objectForKey("gcm_id") != nil){
            gcmId = dict.objectForKey("gcm_id") as! String
        }
        if (dict.objectForKey("driverNumber") != nil){
            driverNumber = dict.objectForKey("driverNumber") as! String
        }
        if (dict.objectForKey("driverName") != nil){
            driverName = dict.objectForKey("driverName") as! String
        }
        if (dict.objectForKey("event") != nil){
            eventId = dict.objectForKey("event") as! String
        }
        if (dict.objectForKey("time") != nil){
            time = dict.objectForKey("time") as! String
            
            let components = ServerUtils.dateFromString(time)!
            self.day = components.day
            self.month = components.month
            self.hour = components.hour
            self.minute = components.minute
        }
        if (dict.objectForKey("passengers") != nil){
            passengers = dict.objectForKey("passengers") as! [String]
        }

    }
}