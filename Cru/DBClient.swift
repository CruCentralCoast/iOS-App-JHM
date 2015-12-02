//
//  CruDBClient.swift
//  Cru
//
//  Created by Peter Godkin on 11/18/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation


class DBClient {
    class func displayListInfo(col : String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) {
        let requestUrl = Config.serverUrl + "api/" + col + "/list";
        sendHttpGetRequest(requestUrl, completionHandler: completionHandler)
    }
    
    class func sendSmsText(phone: String, message: String) {
        let requestUrl = Config.serverUrl + "api/send-sms";
        let params = ["phone":phone, "message":message]
        do {
            let body = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
            sendHttpPostRequest(requestUrl, body: body, completionHandler: blankCompletionHandler)
        } catch {
            print("Error sending sms text")
        }
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
