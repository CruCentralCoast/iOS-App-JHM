//
//  SummerMission.swift
//  Cru
//
//  Created by Quan Tran on 2/2/01.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class SummerMission {
    
    //MARK: Properties
    var id: String
    var slug: String
    var description: String
    var name: String
    var url: String
    var cost: Double
    var leaders: String
    var startDate: NSDateComponents
    var endDate: NSDateComponents
    var country: String
    var state: String
    var suburb: String
    var street: String
    var image: UIImage?

    //MARK: Initialization
    init?(id: String?, slug: String?, description: String?, name: String?, url: String?, cost: Double?, leaders: String?, startDate: String?, endDate: String?, country: String?, state: String?, suburb: String?, street: String?, imageUrl: String?) {
        self.id = id!
        self.slug = slug!
        self.description = description!
        self.name = name!
        self.url = url!
        if (cost != nil) {
            self.cost = cost!
        }
        else {
            self.cost = 9001.0
        }
        self.leaders = leaders!
        self.startDate = GlobalUtils.dateComponentsFromDate(GlobalUtils.dateFromString(startDate!))!
        self.endDate = GlobalUtils.dateComponentsFromDate(GlobalUtils.dateFromString(endDate!))!
        self.country = country!
        self.state = state!
        self.suburb = suburb!
        self.street = street!
        
        if (imageUrl != nil) {
            let cloudURL = NSURL(string: imageUrl!)
            let imageData = NSData(contentsOfURL: cloudURL!)
            self.image = UIImage(data: imageData!)!
        }
    }
    
    convenience init?(dict : NSDictionary) {
        let id = dict["_id"] as! String?
        let slug = dict["slug"] as! String?
        let description = dict["description"] as! String?
        let name = dict["name"] as! String?
        let url = dict["url"] == nil ? "" : dict["url"] as! String?
        let cost = dict["cost"] as! Double?
        let leaders = dict["startDate"] as! String?
        let startDate = dict["startDate"] as! String?
        let endDate = dict["endDate"] as! String?
        let country = dict["location"]?.objectForKey("country") as! String?
        let state = dict["location"]?.objectForKey("state") as! String?
        let suburb = dict["location"]?.objectForKey("suburb") as! String?
        let street = dict["location"]?.objectForKey("street1") as! String?
        let imageUrl = dict["image"]?.objectForKey("secure_url") as! String?
        

        self.init(id: id, slug: slug, description: description, name: name, url: url, cost: cost, leaders: leaders, startDate: startDate, endDate: endDate, country: country, state: state, suburb:suburb, street: street, imageUrl: imageUrl)
    }
}
