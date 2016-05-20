//
//  CommunityGroup.swift
//  Cru
//
//  Created by Max Crane on 5/18/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class CommunityGroup{
    var name : String!
    var description: String!
    var meetingTime: NSDate!
    var leaders : [String]!
    var parentMinitryId : String!
 
    init(name : String){
        self.name = name
    
    }
}
