//
//  Event.swift
//  Cru
//
//  Created by Erica Solum on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit
import Foundation

class Event {
    // MARK: Properties
    
    var name: String
    var image: UIImage?
    var month: String
    var date: Int
    var startTime: String
    var endTime: String
    var startamORpm: String
    var endamORpm: String
    var location: String
    
    
    //MARK: Initialization
    init?(name: String, image: UIImage?, month: String, date: Int, startTime: String, endTime: String, startamORpm: String, endamORpm: String, location: String)
    {
        self.name = name
        self.image = image
        self.month = month
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.startamORpm = startamORpm
        self.endamORpm = endamORpm
        self.location = location
    }
    
}