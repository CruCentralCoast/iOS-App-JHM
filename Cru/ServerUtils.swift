//
//  DBUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class ServerUtils {
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> ()) {
        loadResources(collectionName, inserter: inserter, afterFunc: {() in })
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> (),
        afterFunc : () -> ()) {
        ServerClient.displayListInfo(collectionName, completionHandler: curryDisplayResources(inserter, afterFunc: afterFunc))
    }
    
    
    class func curryDisplayResources(inserter : (NSDictionary) -> (), afterFunc : () -> ()) -> (NSData?, NSURLResponse?, NSError?)-> () {
        return {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    let jsonList = jsonResponse as! NSArray
                    dispatch_async(dispatch_get_main_queue(), {
                        for sm in jsonList {
                            if let dict = sm as? [String: AnyObject]{
                                inserter(dict)
                            }
                        }
                        afterFunc()
                    })
                } else {
                    // TODO: display message for user
                    print("Failed to get stuff from database")
                }
            } catch {
                print("Something went wrong with http request...")
            }
        }
    }
    
    class func dateFromString(dateStr : String) -> NSDateComponents? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(dateStr)
        let unitFlags: NSCalendarUnit = [.Minute, .Hour, .Day, .Month, .Year]
        return NSCalendar.currentCalendar().components(unitFlags, fromDate: date!)
    }
    
    // TODO: add real gcm_id, location, time, radius, direction and handler error better
    class func postRideOffer(eventId : String, name : String , phone : String, seats : Int) {
        let requestUrl = Config.serverUrl + "api/ride/create";
        let params = ["event":eventId, "driverName":name, "driverNumber":phone, "gcm_id":"who knows",
            "seats":seats]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            ServerClient.sendHttpPostRequest(requestUrl, body: body, completionHandler : ServerClient.blankCompletionHandler);
        } catch {
            print("Error sending ride offer!")
        }
    }
}