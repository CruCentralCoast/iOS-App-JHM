//
//  SubscriptionManager.swift
//  Cru
//
//  Created by Max Crane on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class SubscriptionManager{
    static func loadCampuses() -> [Campus]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("campusKey") as? NSData {
            let campuses = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Campus]
            //print("getting \(campuses?.count) campuses")
            return campuses
        }
        return nil
    }
    
    static func saveCampuses(campuses:[Campus]) {
        var enabledCampuses = [Campus]()
        
        for camp in campuses{
            if(camp.feedEnabled == true){
                enabledCampuses.append(camp)
            }
        }
        //TODO: Ensure that unsubscribing from a campus will unsubscribe the associate ministries
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabledCampuses as NSArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: "campusKey")
        defaults.synchronize()
    }
    
    static func loadMinistries() -> [Ministry]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("ministryKey") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Ministry]
        }
        return nil
    }
    
    static func saveMinistrys(ministrys:[Ministry]) {
        var enabledMinistries = [Ministry]()
        
        for camp in ministrys{
            if(camp.feedEnabled == true){
                enabledMinistries.append(camp)
            }
        }
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabledMinistries as NSArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: "ministryKey")
        defaults.synchronize()
    }
    
    static func campusContainsMinistry(campus: Campus, ministry: Ministry)->Bool{
        for campusId in ministry.campusIds{
            if(campusId == campus.id){
                return true
            }
        }
        return false
    }
}