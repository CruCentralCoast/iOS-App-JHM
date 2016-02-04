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
    var seats: String
    var radius: String
    var gcmId: String
    var driverNumber: String
    var driverName: String
    var eventId: String
    var time: String
    
    
    //MARK: Properties

//    var driver:User
//    var passengers:[User]?
//    var seats:Int
//    var event:Event
//    var departureTime:String
//    var departureAddress:String
//    var roundTrip:Bool
//    
//    
//    //MARK: Initialization
//
//    init?(driver:User, seats:Int, event:Event, departureTime:String, departureAddress:String, roundTrip:Bool) {
//        self.driver = driver
//        self.seats = seats
//        self.event = event
//        self.departureTime = departureTime
//        self.departureAddress = departureAddress
//        self.roundTrip = roundTrip
//    }
    
    
    
//    init?(id: String, driverName: String, eventId: String, direction: String){
//        self.id = id
//        self.driverName = driverName
//        self.eventId = eventId
//        self.direction = direction
//    }
    
    init?(dict: NSDictionary){
        id = "blah"
        direction = "both"
        seats = "3"
        radius = "1"
        gcmId = "blah"
        driverNumber = "123456789"
        driverName = "Max crane"
        eventId = "3432432414"
        time = "5:00"

        if (dict.objectForKey("_id") != nil){
            id = dict.objectForKey("_id") as! String
        }
        if (dict.objectForKey("direction") != nil){
            direction = dict.objectForKey("direction") as! String
        }
        if (dict.objectForKey("seats") != nil){
            //seats = dict.objectForKey("seats") as! NSNumber
        }
        if (dict.objectForKey("radius") != nil){
            //radius = dict.objectForKey("radius") as! String
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
        }


        

    }
}