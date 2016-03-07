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
    
    class func saveString(key: String, value: String){
        let archivedObject = NSKeyedArchiver.archivedDataWithRootObject(value)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedObject, forKey: key)
        defaults.synchronize()
    }
    
    class func loadString(key: String)->String{
        if let unarchivedObject = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSData {
            let token = NSKeyedUnarchiver.unarchiveObjectWithData(unarchivedObject) as? String
            return token!
        }
        return ""
    }
}
