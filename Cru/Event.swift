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
    
    var id: String?
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
    var street: String?
    var suburb: String?
    var postcode: String?
    
    
    //MARK: Initialization
    
    init?(name: String?, id: String){
        self.name = name
        self.id = id
    }
    
    init?(id: String?, name: String?, image: UIImage?, startDate: String?, endDate: String?, street: String?, suburb: String?, postcode: String?, description: String?, url: String?, imageUrl: String?)
    {
        self.id = id
        self.name = name
        self.image = image
        
        let startComps = ServerUtils.dateFromString(startDate!)!
        self.month = startComps.month
        self.year = startComps.year
        self.startDay = startComps.day
        self.startHour = startComps.hour
        self.startMinute = startComps.minute
        
        
        let endComps = ServerUtils.dateFromString(endDate!)!
        self.endDay = endComps.day
        self.endHour = endComps.hour
        self.endMinute = endComps.minute
        self.street = street
        self.suburb = suburb
        self.postcode = postcode
        self.description = description
        self.facebookURL = url
        
        if (imageUrl != nil) {
            let cloudUrl = NSURL(string: imageUrl!)
            let imageData = NSData(contentsOfURL: cloudUrl!)
            self.image = UIImage(data: imageData!)
        }
    }
    
    convenience init?(dict : NSDictionary) {
        let id = dict["_id"] as! String?
        let name = dict["name"] as! String?
        let startDate = dict["startDate"] as! String?
        let endDate = dict["endDate"] as! String?
        let street = dict["location"]?.objectForKey("street1") as! String?
        let suburb = dict["location"]?.objectForKey("suburb") as! String?
        let postcode = dict["location"]?.objectForKey("postcode") as! String?
        let description = dict["description"] as! String?
        let url = dict["url"] as! String?
        let imageUrl = dict["image"]?.objectForKey("secure_url") as! String?
        
        
        self.init(id: id, name: name, image: nil, startDate: startDate, endDate: endDate, street: street, suburb: suburb, postcode: postcode, description: description, url: url, imageUrl: imageUrl)
    }

}