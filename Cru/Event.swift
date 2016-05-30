//
//  Event.swift
//  Cru
//  This class stores the data for an event, such as its ID, description, start time, end time, and other data.
//
//  Created by Erica Solum on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//
// Modified by Deniz Tumer on 3/4/16.

import UIKit
import ImageLoader

class Event: Equatable {
    // MARK: Properties
    static let ministriesField = "ministries"
    static let endDateField = "endDate"
    
    //properties in the database for each event
    var id: String
    var url: String
    var description: String
    var name: String
    var notificationDate: String? //notification date is not applicable for every event
    var parentMinistry: String
    var imageSquare: UIImage!
    var imageSquareUrl: String
    var notifications: [String]
    var parentMinistries: [String]
    var rideSharingEnabled: Bool
    var endDate: String
    var endNSDate: NSDate
    var startDate: String
    var startNSDate: NSDate
    var location: NSDictionary?
    var image: UIImage!
    var imageUrl: String
    var rideshareEnabled: Bool?
    
    init?() {
        self.id = ""
        self.url = ""
        self.description = ""
        self.name = ""
        self.notificationDate = ""
        self.parentMinistry = ""
        self.imageSquare = UIImage(named: "event2")
        self.imageSquareUrl = ""
        self.notifications = [String]()
        self.parentMinistries = [String]()
        self.rideSharingEnabled = true
        self.endDate = ""
        self.endNSDate = NSDate()
        self.startDate = ""
        self.startNSDate = NSDate()
        self.image = UIImage(named: "event1")
        self.imageUrl = ""
        self.location = NSDictionary()
        self.rideshareEnabled = false
    }
    
    
    convenience init?(dict : NSDictionary) {
        //init all required variables
        self.init()
        
        //grab dictionary objects
        if let enabled = dict["rideSharing"] as? Bool{
            self.rideSharingEnabled = enabled
        }
        if let dId = dict["_id"] {
            self.id = dId as! String
        }
        if let dUrl = dict["url"] {
            self.url = dUrl as! String
        }
        if let dDescription = dict["description"] {
            self.description = dDescription as! String
        }
        if let dName = dict["name"] {
            self.name = dName as! String
        }
        if let dNotificationDate = dict["notificationDate"] {
            self.notificationDate = dNotificationDate as? String
        }
        if let dParentMinistry = dict["parentMinistry"] {
            self.parentMinistry = dParentMinistry as! String
        }
        if let dImageSquare = dict["imageSquare"] {
            if let imageUrl = dImageSquare.objectForKey("url") {
                self.imageSquareUrl = imageUrl as! String
//                print("SQUARE IMAGE: " + (imageUrl as! String))
            }
        }
        if let dNotifications = dict["notifications"] {
            self.notifications = dNotifications as! [String]
        }
        if let dParentMinistries = dict[Event.ministriesField] {
            self.parentMinistries = dParentMinistries as! [String]
        }
        if let dRideSharingEnabled = dict["rideSharingEnabled"] {
            self.rideSharingEnabled = dRideSharingEnabled as! Bool
        }
        if let dEndDate = dict[Event.endDateField] {
            self.endNSDate = GlobalUtils.dateFromString(dEndDate as! String)
        }
        if let dStartDate = dict["startDate"] {
            self.startNSDate = GlobalUtils.dateFromString(dStartDate as! String)
        }
        if let dLocation = dict["location"] {
            self.location = dLocation as? NSDictionary
        }
        if let dImageLink = dict["imageLink"] {
            self.imageUrl = dImageLink as! String
        }
//        if let dImage = dict["image"] {
//            if let imageUrl = dImage.objectForKey("url") {
//                self.imageUrl = imageUrl as! String
////                print("eventName: " + self.name + ": " + self.imageUrl)
//            }
//        }
    }
    
//    //function for sorting events by date
//    class func sortEventsByDate(event1: Event, event2: Event) -> Bool {
//        return event1.startNSDate.compare(event2.endNSDate) == .OrderedAscending
//    }
    
    //return the location as a string
    func getLocationString() -> String {
        if location != "" {
            let street = location!.objectForKey("street1") as! String
            let suburb = location!.objectForKey("suburb") as! String
            
            return  street + ", " + suburb
        }
        
        return ""
    }
    
    func getTime()->String{
        return GlobalUtils.stringFromDate(startNSDate, format: "M/d/YYYY") + "\n" +
               GlobalUtils.stringFromDate(startNSDate, format: "h:mm a")
        
    }
    
    static func eventsWithRideShare(eventList : [Event])->[Event]{
        var filteredList = [Event]()
        
        for event in eventList{
            if event.rideSharingEnabled {
                filteredList.append(event)
            }
        }
        
        return filteredList
    }
}

func  ==(lEvent: Event, rEvent: Event) -> Bool{
    return lEvent.id == rEvent.id
}