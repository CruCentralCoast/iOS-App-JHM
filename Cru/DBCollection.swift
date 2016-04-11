//
//  DBCollection.swift
//  Cru
//
//  Created by Peter Godkin on 3/12/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

enum DBCollection : String {
    
    case MinistryTeam = "ministryteam"
    case Ride = "ride"
    case Passenger = "passenger"
    case Ministry = "ministry"
    case Campus = "campus"
    case SummerMission = "summermission"
    case Resource = "resource"
    case Event = "event"
    
    func name()->String {
        return self.rawValue
    }
}