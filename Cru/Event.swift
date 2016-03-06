//
//  Event.swift
//  Cru
//
//  Created by Erica Solum on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//
// Modified by Deniz Tumer on 3/4/16.

import UIKit
import Foundation

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
    var startDate: String
    var location: NSDictionary?
    var image: UIImage!
    
    //helper variables for details page
    var startDateMonth: Int
    var startDateYear: Int
    var startDateDay: Int
    var startDateHour: Int
    var startDateMinute: Int

    var endDateMonth: Int
    var endDateYear: Int
    var endDateDay: Int
    var endDateHour: Int
    var endDateMinute: Int
    
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
        self.startDate = ""
        self.image = nil
        
        self.startDateMonth = 1
        self.startDateYear = 2016
        self.startDateDay = 1
        self.startDateHour = 0
        self.startDateMinute = 0
        
        self.endDateMonth = 1
        self.endDateYear = 2016
        self.endDateDay = 1
        self.endDateHour = 0
        self.endDateMinute = 0
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
            let endDateComponents = GlobalUtils.dateFromString(dEndDate as! String)!
            self.endDateMonth = endDateComponents.month
            self.endDateYear = endDateComponents.year
            self.endDateDay = endDateComponents.day
            self.endDateHour = endDateComponents.hour
            self.endDateMinute = endDateComponents.minute
        }
        if let dStartDate = dict["startDate"] {
            let startDateComponents = GlobalUtils.dateFromString(dStartDate as! String)!
            self.startDateMonth = startDateComponents.month
            self.startDateYear = startDateComponents.year
            self.startDateDay = startDateComponents.day
            self.startDateHour = startDateComponents.hour
            self.endDateMinute = startDateComponents.minute
        }
        if let dLocation = dict["location"] {
            self.location = dLocation as! NSDictionary
        }
        if let dImage = dict["image"] {
            if let imageUrl = dImage.objectForKey("secure_url") {
                self.image = GlobalUtils.getImageFromUrl(imageUrl as! String)
            }
        }
    }
}

func  ==(lEvent: Event, rEvent: Event) -> Bool{
    return lEvent.id == rEvent.id
}