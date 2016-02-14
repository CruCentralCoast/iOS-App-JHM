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
    var imageUrl: String!
    var imageData: NSData?
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("name") as! String
        campusIds = aDecoder.decodeObjectForKey("campusIds") as! [String]
        feedEnabled = aDecoder.decodeObjectForKey("feedEnabled") as! Bool
        imageUrl = aDecoder.decodeObjectForKey("imgUrl") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(campusIds, forKey: "campusIds")
        aCoder.encodeObject(feedEnabled, forKey: "feedEnabled")
        aCoder.encodeObject(imageUrl, forKey: "imgUrl")
    }
    
    init(name: String, campusIds: [String], feedEnabled: Bool, imgUrl: String){
        self.name = name
        self.campusIds = campusIds
        self.feedEnabled = feedEnabled
        self.imageUrl = imgUrl
    }
    
    init(name: String, campusIds: [String], imgUrl: String){
        self.name = name
        self.campusIds = campusIds
        self.feedEnabled = false
        self.imageUrl = imgUrl
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let obj = object as? Ministry{
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