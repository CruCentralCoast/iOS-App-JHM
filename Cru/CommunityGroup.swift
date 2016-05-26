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
    var parentMinitry : String!
    
    init(dict: NSDictionary) {
        name = dict["name"] as? String
        description = dict["description"] as? String
        if let dateStr = dict["meetingTime"] as? String {
            meetingTime = GlobalUtils.dateFromString(dateStr)
        }
        leaders = dict["leaders"] as? [String]
        parentMinitry = dict["parentMinistry"] as? String
    }
}
