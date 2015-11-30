//
//  DBUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class DBUtils {
    /*static func loadResources(collectionName : String, tableView : UITableView, curList : NSArray, constructor : (AnyObject) -> AnyObject) {
        print("this happened")
        //CruDBClient.displayListInfo(collectionName, completionHandler: curryDisplayResources(collectionName, tableView, curList, constructor))
    }
    
    static func curryDisplayResources(tableView : UITableView, var curList : [AnyObject], constructor : (AnyObject) -> AnyObject) {
    
        return {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                let jsonList = jsonResponse as! NSArray
                
                var indexPaths : [NSIndexPath] = []
                for sm in jsonList {
                    indexPaths.append(NSIndexPath(forItem: curList.count, inSection: 0))
                    curList.append(constructor(sm))
                    
                }
                tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                tableView.reloadData()
                
                print("this happened too")
                
            } catch {
                print("Something went wrong with http request...")
            }
        }
    }*/
    
    class func dateFromString(dateStr : String) -> NSDateComponents? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(dateStr)
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        return NSCalendar.currentCalendar().components(unitFlags, fromDate: date!)
    }
}