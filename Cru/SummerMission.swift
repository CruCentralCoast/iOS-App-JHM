//
//  SummerMission.swift
//  Cru
//
//  Created by Quan Tran on 2/2/01.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class SummerMission {
    
    //MARK: Properties
    var id: String
    var startDate: NSDate!
    var endDate: NSDate!
    var url: String
    var location: String?
    var image: UIImage!
    var description: String
    var leaders: [User]!
    var cost: Double
    
    
    //MARK: Initialization
    init?(startDate: NSDate, endDate: NSDate, location: String, url: String, image: UIImage,description: String, leaders: [User], cost: Double) {
        self.id = "ID GOES HERE"
        self.startDate = startDate
        self.endDate = endDate
        self.url = url
        self.location = location
        self.image = image
        self.description = description
        self.leaders = leaders
        self.cost = cost
    }
    
    init?(location: String, url: String, description: String, cost: Double) {
        self.id = "ID GOES HERE"
        self.startDate = nil
        self.endDate = nil
        self.url = url
        self.location = location
        self.image = nil
        self.description = description
        self.leaders = nil
        self.cost = cost
    }
}
