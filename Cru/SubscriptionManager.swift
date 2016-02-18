//
//  SubscriptionManager.swift
//  Cru
//
//  Created by Max Crane on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class SubscriptionManager{
    
    static func saveGCMToken(token: String){
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(token)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: "GCM")
        defaults.synchronize()
    }
    
    static func loadGCMToken()->String{
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("GCM") as? NSData {
            let token = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? String
            return token!
        }
        return ""
    }
    
    
    static func loadCampuses() -> [Campus]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("campusKey") as? NSData {
            let campuses = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Campus]
            //print("getting \(campuses?.count) campuses")
            return campuses
        }
        return [Campus]()
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
        return [Ministry]()
    }
    
    static func saveMinistrys(ministrys:[Ministry], updateGCM: Bool) {
        
        var enabledMinistries = [Ministry]()
        
        for min in ministrys{
            if(min.feedEnabled == true){
                enabledMinistries.append(min)
            }
        }
        
        print("updating device ministry data")
        
        if(updateGCM){
            print("updating gcm")
            // unsubcribe from ministries you are no longer in
            // and subscribe to ones that you just joined
            let oldMinistries = loadMinistries()
            if (oldMinistries != nil) {
                for min in oldMinistries! {
                    if (!enabledMinistries.contains(min)) {
                        unSubscribeToTopic("/topics/" + min.id)
                    }
                }
                for min in enabledMinistries {
                    if (!oldMinistries!.contains(min)) {
                        subscribeToTopic("/topics/" + min.id)
                    }
                }
            } else {
                for min in enabledMinistries {
                    subscribeToTopic("/topics/" + min.id)
                }
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
    
    
    // REALLY BAD RACE CONDITIONS EXIST FOR NOW!!!!
    class func subscribeToTopic(topic: String) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        let gcmToken = SubscriptionManager.loadGCMToken()
        dispatch_async(dispatch_get_main_queue(), {
            GCMPubSub.sharedInstance().subscribeWithToken(gcmToken, topic: topic,
                options: nil, handler: {(NSError error) -> Void in
                    if (error != nil) {
                        // Treat the "already subscribed" error more gently
                        if error.code == 3001 {
                            print("Already subscribed to \(topic)")
                        } else {
                            print("Subscription failed: \(error.localizedDescription)");
                        }
                    } else {
                        NSLog("Subscribed to \(topic)");
                    }
            })
        })
    }
    
    class func unSubscribeToTopic(topic: String) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        let gcmToken = SubscriptionManager.loadGCMToken()
        
        dispatch_async(dispatch_get_main_queue(), {
            GCMPubSub.sharedInstance().unsubscribeWithToken(gcmToken, topic: topic,
                options: nil, handler: {(NSError error) -> Void in
                    if (error != nil) {
                        print("Failed to unsubscribe: \(error.localizedDescription)")
                    } else {
                        NSLog("Unsubscribed to \(topic)")
                    }
            })
        })
    }
}