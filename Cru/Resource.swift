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
    var date: NSDate
    var tags: [String]
    var image: UIImage?
    
    init(title: String, url: String, type: String, date: String, tags: [String], image: UIImage?) {
        // Initialize properties
        self.title = title
        self.url = url
        self.type = type
        self.date = NSDate(dateString: date)
        self.tags = tags
        if(image != nil) {
            self.image = image
        }
    }
}

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}