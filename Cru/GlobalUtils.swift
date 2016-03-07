//
//  GlobalUtils.swift
//  Cru
//
//  Created by Deniz Tumer on 3/4/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import UIKit

class GlobalUtils {
    // gets UIImage from cloudinary URL's
    class func getImageFromUrl(imageUrl: String) -> UIImage {
        let cloudUrl = NSURL(string: imageUrl)
        let imageData = NSData(contentsOfURL: cloudUrl!)
        
        return UIImage(data: imageData!)!
    }

    class func dateFromString(dateStr : String) -> NSDateComponents? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(dateStr)
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        return NSCalendar.currentCalendar().components(unitFlags, fromDate: date!)
    }
}
