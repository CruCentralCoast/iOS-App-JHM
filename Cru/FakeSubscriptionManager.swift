//
//  FakeSubscriptionManager.swift
//  Cru
//
//  Created by Peter Godkin on 5/30/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class FakeSubscriptionManager: SubscriptionProtocol {

    private var gcmToken = "emulator-id-hey-whats-up-hello"
    
    private let storageManager: LocalStorageManager
    
    init() {
        storageManager = LocalStorageManager()
    }
    
    init(storageManager: LocalStorageManager) {
        self.storageManager = storageManager
    }
    
    func saveGCMToken(token: String) {
        gcmToken = token
    }
    
    func loadGCMToken()->String {
        return gcmToken
    }
    
    func loadCampuses() -> [Campus] {
        if let unarchivedObject = storageManager.getObject(Config.campusKey) as? NSData {
            if let campuses = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Campus]{
                return campuses
            }
        }
        return [Campus]()
    }
    
    func saveCampuses(campuses:[Campus]) {
        let enabled = campuses.filter{ $0.feedEnabled }
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabled as NSArray)
        storageManager.putObject(Config.campusKey, object: archivedObject)
    }
    
    func loadMinistries() -> [Ministry] {
        if let unarchivedObject = storageManager.getObject(Config.ministryKey) as? NSData {
            if let ministries = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? [Ministry]{
                return ministries
            }
        }
        return [Ministry]()
    }
    
    func saveMinistries(ministries:[Ministry], updateGCM: Bool) {
        let enabled = ministries.filter{ $0.feedEnabled }
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(enabled as NSArray)
        storageManager.putObject(Config.ministryKey, object: archivedObject)
    }
    
    func campusContainsMinistry(campus: Campus, ministry: Ministry)->Bool {
        return ministry.campusId == campus.id
    }
    
    func subscribeToTopic(topic: String) {
        //doesn't need to do anything
    }
    
    func subscribeToTopic(topic: String, handler: (Bool) -> Void) {
        handler(true)
    }
    
    func unsubscribeToTopic(topic: String) {
        //doesn't need to do anything
    }
    
    func unsubscribeToTopic(topic: String, handler: (Bool) -> Void) {
        handler(true)
    }
}