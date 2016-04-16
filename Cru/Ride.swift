//
//  Ride.swift
//  Cru
//
//  Created by Quan Tran on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Ride: Comparable, Equatable, TimeDetail {
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
    var monthNum = 1
    var hour = 3
    var minute = 3
    var year = 2016
    var date : NSDate?
    var postcode: String = ""
    var state: String = ""
    var suburb: String = ""
    var street: String = ""
    var gender: Int = 0
    
    
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
        
        
        if (dict.objectForKey("location") != nil){
            let loc = dict.objectForKey("location") as! NSDictionary
            
            if let postcode = loc["postcode"] as? String{
                //something
            }
            if (loc["state"] != nil){
                state = loc["state"] as! String
            }
            if (loc["suburb"] != nil){
                suburb = loc["suburb"] as! String
            }
            if (loc["street1"] != nil){
                street = loc["street1"] as! String
            }
        }
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
            self.date = GlobalUtils.dateFromString(time)
            
            let components = GlobalUtils.dateComponentsFromDate(GlobalUtils.dateFromString(time))!
            self.day = components.day
            let monthNumber = components.month
            self.hour = components.hour
            self.minute = components.minute
            self.year = components.year
            self.time = getTime()//Ride.createTime(self.hour, minute: self.minute)
            
            //get month symbol from number
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            let months = dateFormatter.shortMonthSymbols
            self.month = months[monthNumber - 1].uppercaseString
            self.monthNum = monthNumber
        }
        if (dict.objectForKey("passengers") != nil){
            passengers = dict.objectForKey("passengers") as! [String]
        }

    }
    
    func getCompleteAddress()->String{
        var address: String = ""
        
        if(street != ""){
            address += street
        }
        if(postcode != ""){
            address += ", " + postcode
        }
        if(suburb != ""){
            address += ", " + suburb
        }
        if(state != ""){
            address += ", " + state
        }
        
        return address
    }
    
    func getTime()->String{
        let dFormat = "h:mm a MMMM d, yyyy"
        return GlobalUtils.stringFromDate(self.date!, format: dFormat)
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
}

func  <(lRide: Ride, rRide: Ride) -> Bool{
    if(lRide.year < rRide.year){
        return true
    }
    else if(lRide.year > rRide.year){
        return false
    }
    if(lRide.monthNum < rRide.monthNum){
        return true
    }
    else if(lRide.monthNum > rRide.monthNum){
        return false
    }
    
    if(lRide.day < rRide.day){
        return true
    }
    else if(lRide.day > rRide.day){
        return false
    }
    return false
}
func  ==(lRide: Ride, rRide: Ride) -> Bool{
    return lRide.id == rRide.id
}