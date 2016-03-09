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

    //gets an NSDate from a given string
    class func dateFromString(dateStr: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        //if date formatter returns nil return the current date/time
        if let date = dateFormatter.dateFromString(dateStr) {
            return date
        }
        else {
            return NSDate()
        }
    }
    
//    //compresses two date strings into one
//    class func stringCompressionOfDates(date1: NSDate, date2: NSDate) -> String {
//        let date1Comp = GlobalUtils.dateComponentsFromDate(date1)!
//        let date2Comp = GlobalUtils.dateComponentsFromDate(date2)!
//        
//        var returnString = ""
//        var yearString = ""
//        var monthString = ""
//        var dayString = ""
//        
//        //if years same
//        if date1Comp.year == date2Comp.year {
//            yearString = GlobalUtils.stringFromDate(date1, format: "yyyy")
//            
//            //if months and days same
//            if date1Comp.month == date2Comp.month && date1Comp.day == date2Comp.day {
//                monthString = GlobalUtils.stringFromDate(date1, format: "MMMM")
//                dayString = GlobalUtils.stringFromDate(date1, format: "d")
//                
//                let dFormat = "h:mma"
//                returnString += GlobalUtils.stringFromDate(date1, format: dFormat) + "-" + GlobalUtils.stringFromDate(date2, format: dFormat) + " " + monthString + " " + dayString + ", " + yearString
//            }
//            else {
//                let dFormat = "h:mma MMMM d"
//                returnString += GlobalUtils.stringFromDate(date1, format: dFormat) + " - " + GlobalUtils.stringFromDate(date2, format: dFormat) + yearString
//            }
//        }
//        else {
//            let dFormat = "h:mma MMMM d, yyyy"
//            
//            returnString += GlobalUtils.stringFromDate(date1, format: dFormat) + " - " + GlobalUtils.stringFromDate(date2, format: dFormat)
//        }
//        
//        return returnString
//    }
    
    //return appropriate string representation of NSDate object
    class func stringFromDate(date: NSDate, format: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        
        return formatter.stringFromDate(date)
    }
    
    //gets date components from an NSDate
    class func dateComponentsFromDate(date: NSDate) -> NSDateComponents? {
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        
        return NSCalendar.currentCalendar().components(unitFlags, fromDate: date)
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
