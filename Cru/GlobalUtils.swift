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
    
    //load dictionary object from user defaults
    class func loadDictionary(key: String) -> NSDictionary? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let unarchivedObject = userDefaults.objectForKey(key) {
            return unarchivedObject as? NSDictionary
        }
        
        return nil
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
    
    class func printRequest(params: AnyObject) {
        do {
            let something = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            let string1 = NSString(data: something, encoding: NSUTF8StringEncoding)
            print(string1)
        } catch {
            print("Error writing json body")
        }
    }
}
