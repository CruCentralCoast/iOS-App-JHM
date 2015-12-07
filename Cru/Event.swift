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
    
    //DENIZ DON'T DELETE MY SHIT
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
    
    init?(name: String?, image: UIImage?, startDate: String?, endDate: String?, location: String?, description: String?, url: String?, imageUrl: String?)
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
        self.facebookURL = url
        
        if (imageUrl != nil) {
            let cloudUrl = NSURL(string: imageUrl!)
            let imageData = NSData(contentsOfURL: cloudUrl!)
            self.image = UIImage(data: imageData!)
        }
    }
    
    convenience init?(dict : NSDictionary) {
        let name = dict["name"] as! String?
        let startDate = dict["startDate"] as! String?
        let endDate = dict["endDate"] as! String?
        let location = "Mars"
        let description = dict["description"] as! String?
        let url = dict["url"] as! String
        let imageUrl = dict["image"]?.objectForKey("secure_url") as? String
        
        self.init(name: name, image: nil, startDate: startDate, endDate: endDate, location: location, description: description, url: url, imageUrl: imageUrl)
    }

}