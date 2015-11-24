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
    
    
    //MARK: Initialization
    init?(name: String, image: UIImage?)
    {
        self.name = name
        self.image = image
    }
    
}