//
//  SubscriptionManager.swift
//  Cru
//
//  Created by Max Crane on 1/21/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import Google

class SubscriptionManager: SubscriptionProtocol {
    
    func saveGCMToken(token: String){
        GlobalUtils.saveString("GCM", value: token)
    }
    
    func loadGCMToken()->String{
        return GlobalUtils.loadString("GCM")
    }
    
    func loadCampuses() -> [Campus] {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(Config.campusKey) as? NSData {
            if let campuses = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Campus]{
                return campuses
            }
        }
        return [Campus]()
    }
    
    func saveCampuses(campuses:[Campus]) {
        var enabledCampuses = [Campus]()
        
        for camp in campuses{
            if(camp.feedEnabled == true){
                enabledCampuses.append(camp)
            }
        }
        //TODO: Ensure that unsubscribing from a campus will unsubscribe the associate ministries
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabledCampuses as NSArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: Config.campusKey)
        defaults.synchronize()
    }
    
    func loadMinistries() -> [Ministry] {
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(Config.ministryKey) as? NSData {
            if let minisArr = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Ministry]{
                return minisArr
            }
        }
        return [Ministry]()
    }
    
    func saveMinistries(ministries:[Ministry], updateGCM: Bool) {
        
        var enabledMinistries = [Ministry]()
        
        for min in ministries {
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
            for min in oldMinistries {
                if (!enabledMinistries.contains(min)) {
                    unsubscribeToTopic("/topics/" + min.id)
                }
            }
            for min in enabledMinistries {
                if (!oldMinistries.contains(min)) {
                    subscribeToTopic("/topics/" + min.id)
                }
            }
        }
        
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabledMinistries as NSArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: Config.ministryKey)
        defaults.synchronize()
    }
    
    func campusContainsMinistry(campus: Campus, ministry: Ministry)->Bool{
        return ministry.campusId == campus.id
    }
    
    func subscribeToTopic(topic: String) {
        subscribeToTopic(topic, handler : {(success) in })
    }
    
    func subscribeToTopic(topic: String, handler: (Bool) -> Void) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        let gcmToken = loadGCMToken()
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
    
    func unsubscribeToTopic(topic: String) {
        unsubscribeToTopic(topic, handler : {(success) in })
    }

    func unsubscribeToTopic(topic: String, handler: (Bool) -> Void) {
        // If the app has a registration token and is connected to GCM, proceed to subscribe to the
        // topic
        
        let gcmToken = loadGCMToken()
        
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