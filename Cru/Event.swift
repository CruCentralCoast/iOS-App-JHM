//
//  Event.swift
//  Cru
//
//  Created by Erica Solum on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//
// Modified by Deniz Tumer on 3/4/16.

import UIKit

class Event: Equatable {
    // MARK: Properties
    
    //properties in the database for each event
    var id: String
    var url: String
    var description: String
    var name: String
    var notificationDate: String? //notification date is not applicable for every event
    var parentMinistry: String
    var imageSquare: UIImage!
    var notifications: [String]
    var parentMinistries: [String]
    var rideSharingEnabled: Bool
    var endDate: String
    var endNSDate: NSDate
    var startDate: String
    var startNSDate: NSDate
    var location: NSDictionary?
    var image: UIImage!
    
    init?() {
        self.id = ""
        self.url = ""
        self.description = ""
        self.name = ""
        self.notificationDate = ""
        self.parentMinistry = ""
        self.imageSquare = nil
        self.notifications = [String]()
        self.parentMinistries = [String]()
        self.rideSharingEnabled = true
        self.endDate = ""
        self.endNSDate = NSDate()
        self.startDate = ""
        self.startNSDate = NSDate()
        self.image = nil
    }
    
    convenience init?(dict : NSDictionary) {
        //init all required variables
        self.init()
        
        //grab dictionary objects
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
            if let imageUrl = dImageSquare.objectForKey("secure_url") {
                self.imageSquare = GlobalUtils.getImageFromUrl(imageUrl as! String)
            }
        }
        if let dNotifications = dict["notifications"] {
            self.notifications = dNotifications as! [String]
        }
        if let dParentMinistries = dict["parentMinistries"] {
            self.parentMinistries = dParentMinistries as! [String]
        }
        if let dRideSharingEnabled = dict["rideSharingEnabled"] {
            self.rideSharingEnabled = dRideSharingEnabled as! Bool
        }
        if let dEndDate = dict["endDate"] {
            self.endNSDate = GlobalUtils.dateFromString(dEndDate as! String)
        }
        if let dStartDate = dict["startDate"] {
            self.startNSDate = GlobalUtils.dateFromString(dStartDate as! String)
        }
        if let dLocation = dict["location"] {
            self.location = dLocation as? NSDictionary
        }
        if let dImage = dict["image"] {
            if let imageUrl = dImage.objectForKey("secure_url") {
                self.image = GlobalUtils.getImageFromUrl(imageUrl as! String)
            }
        }
    }
    
    //function for sorting events by date
    class func sortEventsByDate(event1: Event, event2: Event) -> Bool {
        return event1.startNSDate.compare(event2.endNSDate) == .OrderedAscending
    }
}

func  ==(lEvent: Event, rEvent: Event) -> Bool{
    return lEvent.id == rEvent.id
}