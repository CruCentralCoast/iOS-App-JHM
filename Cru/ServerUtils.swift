//
//  DBUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class ServerUtils {

    static func findEventById(id: String, inserter : (NSDictionary) -> ()){
        let requestUrl = Config.serverUrl + "api/event/find"
        let params = ["_id": id]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            sendHttpPostRequest(requestUrl, body: body, completionHandler : {(data : NSData?, response : NSURLResponse?, error : NSError?) in
                do {
                    if (data != nil) {
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        let event = jsonResponse as! NSArray

                        if(event.count != 0){
                        inserter(event[0] as! NSDictionary)
                        }
                        else
                        {
                            print("couldn't find event for id")
                        }
                        
                    }
                    else {
                        // TODO: display message for user
                        print("Failed to get stuff from database")
                    }
                }
                catch {
                    print("Something went wrong with http request...")
                }})
        }
        catch {
            print("Error getting ride for GCM token!")
        }
    }
    
    static func findPassengerById(id: String, inserter : (NSDictionary) -> ()){
        var requestUrl = Config.serverUrl + "api/passenger/find"
        var params = ["_id": id]
        
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            sendHttpPostRequest(requestUrl, body: body, completionHandler : {(data : NSData?, response : NSURLResponse?, error : NSError?) in
                do {
                    if (data != nil) {
                        let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                        
                        let event = jsonResponse as! NSArray
                        
                        if(event.count != 0){
                            inserter(event[0] as! NSDictionary)
                        }
                        else
                        {
                            print("couldn't find passenger for id")
                        }
                        
                    }
                    else {
                        // TODO: display message for user
                        print("Failed to get stuff from database")
                    }
                }
                catch {
                    print("Something went wrong with http request...")
                }})
        }
        catch {
            print("Error getting ride for GCM token!")
        }
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> ()) {
        loadResources(collectionName, inserter: inserter, afterFunc: {() in })
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> (),
        afterFunc : () -> ()) {
        displayListInfo(collectionName, completionHandler: curryDisplayResources(inserter, afterFunc: afterFunc))
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
    
    class func displayListInfo(col : String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) {
        let requestUrl = Config.serverUrl + "api/" + col + "/list";
        sendHttpGetRequest(requestUrl, completionHandler: completionHandler)
    }
    
    
    class func blankCompletionHandler(data : NSData?, response : NSURLResponse?, error : NSError?) {
        
    }
    
    class func sendHttpGetRequest(reqUrl : String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        let requestUrl = NSURL(string: reqUrl)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler : completionHandler)
        
        task.resume()
        
        return task
    }
    
    class func sendHttpPostRequest(reqUrl : String, body : NSData, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        let requestUrl = NSURL(string: reqUrl)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = body
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler : completionHandler)
        
        task.resume()
        
        return task
    }

}