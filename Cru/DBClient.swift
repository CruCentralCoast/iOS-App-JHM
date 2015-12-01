//
//  CruDBClient.swift
//  Cru
//
//  Created by Peter Godkin on 11/18/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation


class DBClient {
    //static var serverUrl = "http://localhost:3000/"
    static var serverUrl = "http://pcp129516pcs.wireless.calpoly.edu:3000/"

    class func displayListInfo(col : String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) {
        let requestUrl = serverUrl + "api/" + col + "/list";
        sendHttpRequest(requestUrl, reqMethod: "GET", completionHandler: completionHandler)
    }
    
    class func sendHttpRequest(reqUrl : String, reqMethod : String, completionHandler : (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask {
        let requestUrl = NSURL(string: reqUrl)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = reqMethod
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler : completionHandler)
        
        task.resume()
        
        return task
    }
}
