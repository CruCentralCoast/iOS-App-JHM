//
//  Ride.swift
//  Cru
//
//  Created by Quan Tran on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Ride: Comparable, Equatable {
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
    var month = "JAN"
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
        eventId = "563b11135e926d03001ac15c"
        time = "5:00 pm"
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
            let monthNum = components.month
            self.hour = components.hour
            self.minute = components.minute
            
            self.time = Ride.createTime(self.hour, minute: self.minute)
            
            //get month symbol from number
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            let months = dateFormatter.shortMonthSymbols
            self.month = months[monthNum - 1].uppercaseString
        }
        if (dict.objectForKey("passengers") != nil){
            passengers = dict.objectForKey("passengers") as! [String]
        }

    }
    
    static func createTime(hour: Int, minute: Int)->String{
        var period = "am"
        var newHour = hour
        var minuteAsString = ""
        
        
        if(hour > 12){
            period = "pm"
            newHour = hour - 12
        }
        
        if(minute < 10){
            minuteAsString = "0" + String(minute)
        }
        else{
            minuteAsString = String(minute)
        }
        
        
        return String(newHour) + ":" + minuteAsString + " " + period
    }
    
    func getTime()->String{
        return Ride.createTime(self.hour, minute: self.minute)
    }
    
    func hasSeats()->Bool{
        return (self.seats - passengers.count)  != 0
    }
    
    func seatsLeft()->String{
        return String(self.seats - self.passengers.count)
    }
    
    func seatsLeft()->Int{
        return self.seats - self.passengers.count
    }
    
    
    
    func getDate()->String{
        var dayS = String(self.day)
        if(self.day < 10){
            dayS = "0" + String(self.day)
        }


        return String(self.month.lowercaseString) + "/" + dayS
    }
    
    func getDescription()->String{
        return Ride.createTime(self.hour, minute: self.minute)  + "    " + self.getDate() + "   " + self.seatsLeft() + " left"
    }
    
    
}

func  <(lRide: Ride, rRide: Ride) -> Bool{
    return lRide.id < rRide.id
}
func  ==(lRide: Ride, rRide: Ride) -> Bool{
    return lRide.id == rRide.id
}