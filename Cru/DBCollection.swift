//
//  DBCollection.swift
//  Cru
//
//  Created by Peter Godkin on 3/12/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

enum DBCollection : String {
    
    case MinistryTeam = "ministryteams"
    case Ride = "rides"
    case Passenger = "passengers"
    case Ministry = "ministries"
    case Campus = "campuses"
    case SummerMission = "summermissions"
    case Resource = "resources"
    case Event = "events"
    case MinistyQuestion = "ministryquestions"
    
    case Question = "questions" //subsection of ministry
    
    func name()->String {
        return self.rawValue
    }
}