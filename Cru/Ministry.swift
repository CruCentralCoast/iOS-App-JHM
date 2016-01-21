//
//  Campus.swift
//  Cru
//
//  Created by Max Crane on 11/29/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class Ministry: NSObject, NSCoding, Comparable{
    let name: String!
    let campusIds: [String]!
    var feedEnabled: Bool!
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        campusIds = aDecoder.decodeObjectForKey("campusIds") as! [String]
        feedEnabled = aDecoder.decodeObjectForKey("feedEnabled") as! Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(campusIds, forKey: "campusIds")
        aCoder.encodeObject(feedEnabled, forKey: "feedEnabled")
    }
    
    init(name: String, campusIds: [String], feedEnabled: Bool){
        self.name = name
        self.campusIds = campusIds
        self.feedEnabled = feedEnabled
    }
    
    init(name: String, campusIds: [String]){
        self.name = name
        self.campusIds = campusIds
        self.feedEnabled = false
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let obj = object as? Campus{
            return obj.name == self.name
        }
        else{
            return false
        }
    }
    
}

func  <(lCampus: Ministry, rCampus: Ministry) -> Bool{
    return lCampus.name < rCampus.name
}