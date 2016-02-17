//
//  Resource.swift
//  Cru
//
//  Created by Erica Solum on 2/13/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class Resource {
    // MARK: Properties
    var title: String
    var url: String
    var type: String
    var date: String
    var tags: [String]
    var imageName: String
    
    init(title: String, url: String, type: String, date: String, tags: [String], imageName: String) {
        // Initialize properties
        self.title = title
        self.url = url
        self.type = type
        self.date = date
        self.tags = tags
        self.imageName = imageName
    }
}

//Temporary extension (Should move this later)
/*extension NSDate
{
    convenience init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
} */