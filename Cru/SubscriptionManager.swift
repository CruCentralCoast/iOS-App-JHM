//
//  SubscriptionManager.swift
//  Cru
//
//  Created by Max Crane on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import Google

class SubscriptionManager{
    
    static func saveGCMToken(token: String){
        GlobalUtils.saveString("GCM", value: token)
    }
    
    static func loadGCMToken()->String{
        return GlobalUtils.loadString("GCM")
    }
    
    static func loadCampuses() -> [Campus]? {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey("campusKey") as? NSData {
            if let campuses = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Campus]{
                return campuses
            }
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
            if let minisArr = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Ministry]{
                return minisArr
            }
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
                        unsubscribeToTopic("/topics/" + min.id)
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
        if(ministry.campusId == campus.id){
            return true
        }
        return false
    }
    
    
    // REALLY BAD RACE CONDITIONS EXIST FOR NOW!!!!
    
    class func subscribeToTopic(topic: String) {
        subscribeToTopic(topic, handler : {(success) in })
    }
    
    class func subscribeToTopic(topic: String, handler: (Bool) -> Void) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        let gcmToken = SubscriptionManager.loadGCMToken()
        GCMPubSub.sharedInstance().subscribeWithToken(gcmToken, topic: topic,
            options: nil, handler: {(NSError error) -> Void in
                var success : Bool = false
                if (error != nil) {
                    // Treat the "already subscribed" error more gently
                    if error.code == 3001 {
                        print("Already subscribed to \(topic)")
                    } else {
                        print("Subscription failed: \(error.localizedDescription)");
                    }
                } else {
                    success = true
                    NSLog("Subscribed to \(topic)");
                }
                handler(success)
        })
    }
    
    class func unsubscribeToTopic(topic: String) {
        unsubscribeToTopic(topic, handler : {(success) in })
    }

    class func unsubscribeToTopic(topic: String, handler: (Bool) -> Void) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        
        let gcmToken = SubscriptionManager.loadGCMToken()
        
        GCMPubSub.sharedInstance().unsubscribeWithToken(gcmToken, topic: topic,
            options: nil, handler: {(NSError error) -> Void in
                var success : Bool = false
                if (error != nil) {
                    print("Failed to unsubscribe: \(error.localizedDescription)")
                } else {
                    success = true
                    NSLog("Unsubscribed to \(topic)")
                }
                handler(success)
        })
    }
}