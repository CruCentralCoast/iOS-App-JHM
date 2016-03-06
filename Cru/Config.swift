//
//  Config.swift
//  Cru
//
//  Created by Peter Godkin on 12/1/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

struct Config {
    static let serverUrl = "http://ec2-52-32-197-212.us-west-2.compute.amazonaws.com:3000/"
    static let ministryCollection = "ministry"
    static let name = "name"
    static let campusIds = "campuses"
    static let campusCollection = "campus"
    static let globalTopic = "/topics/global"
    static let emulatorGcmId = "emulator-id-hey-whats-up-hello"
    static let leaderApiKey = "LeaderAPIKey"
    static let username = "username"
    
    /* Configureations for Events */
    //reuse identifier for event collection cells
    static let eventReuseIdentifier = "event"
    //resourse loader key for events
    static let eventResourceLoaderKey = "event"
    
    /* Configurations for Ministry Teams */
    //reuse identifier for collection cells in Ministry Teams
    static let ministryTeamReuseIdentifier = "ministryteam"
    //identifier for ministry team resource loading
    static let ministryTeamResourceLoaderKey = "ministryteam"
    //configuration key for NSUserDefaults ministry teams
    static let ministryTeamNSDefaultsKey = "ministryTeams"
    
    
    // Modal header and footer text color
    static let textColor = UIColor(red: 0.188, green: 0.188, blue: 0.188, alpha: 1.0)
    // Modal background color
    static let introModalBackgroundColor = UIColor.whiteColor()
    
    // Content View Color For Modals
    static let introModalContentColor = UIColor(red: 0.8824, green: 0.8824, blue: 0.8824, alpha: 1.0)
    // Content Text Color
    static let introModalContentTextColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
}