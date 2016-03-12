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
    
    func name()->String {
        return self.rawValue
    }
}