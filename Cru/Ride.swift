//
//  Ride.swift
//  Cru
//
//  Created by Quan Tran on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Ride {
    let id: String
    let driverName: String
    
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
    
    init?(id: String, driverName: String){
        self.id = id
        self.driverName = driverName
    }
}