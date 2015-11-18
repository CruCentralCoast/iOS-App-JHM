//
//  CruDBClient.swift
//  Cru
//
//  Created by Peter Godkin on 11/18/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

class CruDBClient {
    let serverUrl = "http://localhost:3000/"
    var something : String
    
    init() {
        self.something = "Maxxx Crane"
    }
    
    func getSomething() -> String {
        return self.something
    }
    
    func getCollection() {
        
        
        
    }
    
    func sendHttpRequest(reqUrl : String, reqMethod : String) ->NSURLSessionDataTask {
        let requestUrl = NSURL(string: reqUrl)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = reqMethod
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(date: NSData?, response: NSURLResponse?, error: NSError?) in
            //do something
            print(self.something)
        })
        
        task.resume()
        
        return task
    }
}
