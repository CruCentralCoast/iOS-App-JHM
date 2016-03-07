//
//  DBUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation
import Alamofire

class ServerUtils {

    static func findEventById(id: String, inserter : (NSDictionary) -> ()){
        let requestUrl = Config.serverUrl + "api/event/" + id
        
        sendHttpGetRequest(requestUrl, completionHandler : {(response : AnyObject) in
            inserter(response as! NSDictionary)
        })
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> ()) {
        loadResources(collectionName, inserter: inserter, afterFunc: {() in })
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> (),
        afterFunc : () -> ()) {
        displayListInfo(collectionName, completionHandler: insertResources(inserter, afterFunc: afterFunc))
    }
    
    class func insertResources(inserter : (NSDictionary) -> (), afterFunc : () -> ()) -> (AnyObject)-> () {
        return {(response : AnyObject) in
            let jsonList = response as! NSArray
            dispatch_async(dispatch_get_main_queue(), {
                for sm in jsonList {
                    if let dict = sm as? [String: AnyObject]{
                        inserter(dict)
                    }
                }
                afterFunc()
            })
        }
    }
    
    class func displayListInfo(col : String, completionHandler : (AnyObject) -> Void) {
        let requestUrl = Config.serverUrl + "api/" + col + "/list";
        sendHttpGetRequest(requestUrl, completionHandler: completionHandler)
    }
    
    class func sendHttpGetRequest(reqUrl : String, completionHandler : (AnyObject) -> Void) -> NSURLSessionDataTask {
        let requestUrl = NSURL(string: reqUrl)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler : {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    completionHandler(jsonResponse)
                }
                else {
                    // TODO: display message for user
                    print("Failed to get stuff from database")
                }
            }
            catch {
                print("Something went wrong with http request...")
            }
        })
        
        task.resume()
        
        return task
    }
    
    class func sendHttpPostRequest(reqUrl : String, body : NSDictionary) -> NSURLSessionDataTask {
        return sendHttpPostRequest(reqUrl, body: body, completionHandler : {(response : AnyObject) in ()})
    }
    
    class func sendHttpPostRequest(reqUrl : String, body : NSDictionary, completionHandler : (AnyObject) -> Void) -> NSURLSessionDataTask {
        let requestUrl = NSURL(string: reqUrl)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
            let string1 = NSString(data: request.HTTPBody!, encoding: NSUTF8StringEncoding)
            print(string1)
        } catch {
            print("Error writing json body")
        }
        
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler : {(data : NSData?, response : NSURLResponse?, error : NSError?) in
            do {
                if (data != nil) {
                    let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    completionHandler(jsonResponse)
                }
                else {
                    // TODO: display message for user
                    print("Failed to get stuff from database")
                }
            }
            catch {
                print("Something went wrong with http request...")
            }
        })
        
        task.resume()
        
        return task
    }
    
    //send push notification if possible, otherwise send text
    class func joinMinistryTeam(ministryTeamId: String, callback: (NSArray) -> Void) {
        let url = Config.serverUrl + "api/minstryteam/join/" + ministryTeamId
        
        Alamofire.request(.POST, url, parameters: nil).responseJSON {
            response in
            
            //let leaders = response.result.value as! NSArray
            let leaders = [String]()
            callback(leaders)
        }
    }
}