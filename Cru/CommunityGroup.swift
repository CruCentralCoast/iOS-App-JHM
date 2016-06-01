//
//  CommunityGroup.swift
//  Cru
//
//  Created by Max Crane on 5/18/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class CommunityGroup{
    var id: String!
    var name : String!
    var description: String!
    var meetingTime: String!
    var leaders : [String]!
    var parentMinitry : String!
    
    init(dict: NSDictionary) {
        id = dict["_id"] as? String
        name = dict["name"] as? String
        description = dict["description"] as? String
        if let dateStr = dict["meetingTime"] as? String {
            //the date is in a different format from other dates
            // just going to use the string for now
            meetingTime = dateStr//GlobalUtils.dateFromString(dateStr)
        }
        leaders = dict["leaders"] as? [String]
        parentMinitry = dict["parentMinistry"] as? String
    }
    
    func getMeetingTime()->String{
        let format = "E h:mm a"
        let serverFormat = "E M d y H:m:s"
  
        let formatter = NSDateFormatter()
        formatter.dateFormat = serverFormat
        
        let parsedMeetingTime = meetingTime.substringWithRange(Range<String.Index>(start: meetingTime.startIndex, end: meetingTime.endIndex.advancedBy(-14)))
        let meetingTimeAsDate = formatter.dateFromString(parsedMeetingTime)
        formatter.dateFormat = format
        
        if (meetingTimeAsDate != nil){
            return formatter.stringFromDate(meetingTimeAsDate!)
        }
        else{
            return ""
        }
    }
}
