//
//  Event.swift
//  Cru
//
//  Created by Erica Solum on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import Foundation

class Event {
    // MARK: Properties
    var id: String
    var name: String?
    var image: UIImage?
    var month: Int?
    var year: Int?
    var startDay: Int?
    var startHour: Int?
    var startMinute: Int?
    var endDay: Int?
    var endHour: Int?
    var endMinute: Int?
    var location: String?
    var description: String?
    var facebookURL: String?
    
    
    //MARK: Initialization
    init?(name: String, image: UIImage?, month: Int, year: Int, startDay: Int, startHour: Int, startMinute: Int, endDay: Int, endHour: Int, endMinute: Int, location: String, description: String)
    {
        self.id = "boo"
        self.name = name
        self.image = image
        self.month = month
        self.year = year
        self.startDay = startDay
        self.startHour = startHour
        self.startMinute = startMinute
        self.endDay = endDay
        self.endHour = endHour
        self.endMinute = endMinute
        self.location = location
        self.description = description
    }
    
    init?(name: String?, image: UIImage?, startDate: String?, endDate: String?, location: String?, description: String?)
    {
        self.id = "boo"
        self.name = name
        self.image = image
        
        let startComps = DBUtils.dateFromString(startDate!)!
        self.month = startComps.month
        self.year = startComps.year
        self.startDay = startComps.day
        self.startHour = startComps.hour
        self.startMinute = startComps.minute
        
        
        let endComps = DBUtils.dateFromString(endDate!)!
        self.endDay = endComps.day
        self.endHour = endComps.hour
        self.endMinute = endComps.minute
        self.location = location
        self.description = description
    }
    
    /*init?(json : AnyObject) {
        if let dict = json as? [String: AnyObject]{
            
        } else {
            return nil
        }
    }*/

}