//
//  ServerUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//
//  Class of static methods that communicate with keystone server using HTTP requests.
//  Made to simplify interactions with the server.
//

import Alamofire

class ServerUtils {
    
    
    //Sends a request for all items in the specified collection and calls the inserter method
    //passed in for each item returned. AfterFunc is called after all the insert calls are done
    
    class func loadResources(collection : DBCollection, inserter : (NSDictionary) -> ()) {
        loadResources(collection, inserter: inserter, afterFunc: {() in }, useApiKey: false)
    }
    
    class func loadResources(collection : DBCollection, inserter : (NSDictionary) -> (), useApiKey : Bool) {
        loadResources(collection, inserter: inserter, afterFunc: {() in }, useApiKey: useApiKey)
    }
    
    class func loadResources(collection : DBCollection, inserter : (NSDictionary) -> (), afterFunc : () -> ()) {
        
        loadResources(collection, inserter: inserter, afterFunc: afterFunc, useApiKey: false)
    }
    
    class func loadResources(collection : DBCollection, inserter : (NSDictionary) -> (), afterFunc : () -> (), useApiKey: Bool) {
        
        var requestUrl = Config.serverUrl + "api/" + collection.name();
        if (useApiKey && LoginUtils.isLoggedIn()) {
            requestUrl += "?" + Config.leaderApiKey + "=" + GlobalUtils.loadString(Config.leaderApiKey)
        }
        
        sendHttpGetRequest(requestUrl, completionHandler: insertResources(inserter, afterFunc: afterFunc))
    }
    
    // Made to simplify writing callbacks by automatically getting items from server response and inserting
    // them into a local array for you
    
    class func insertResources(inserter : (NSDictionary) -> ()) -> (AnyObject)-> () {
        return insertResources(inserter, afterFunc: {() in })
    }
    
    class func insertResources(inserter : (NSDictionary) -> (), afterFunc : () -> ()) -> (AnyObject)-> () {
        return {(response : AnyObject) in
            let jsonList = response as! NSArray
            for sm in jsonList {
                if let dict = sm as? [String: AnyObject]{
                    inserter(dict)
                }
            }
            afterFunc()
        }
    }

    //The following "sendHttp" functions use Alamofire to send http requests to the specified url
    
    class func sendHttpGetRequest(reqUrl : String, completionHandler : (AnyObject) -> Void) {
        sendHttpRequest(.GET, reqUrl: reqUrl, body: [:], completionHandler: completionHandler)
    }
    
    class func sendHttpPostRequest(reqUrl : String, body : [String : AnyObject]) {
        sendHttpPostRequest(reqUrl, body: body, completionHandler : {(response : AnyObject) in ()})
    }
    
    class func sendHttpPostRequest(reqUrl : String, body : [String : AnyObject], completionHandler : (AnyObject) -> Void) {
        sendHttpRequest(.POST, reqUrl: reqUrl, body: body, completionHandler: completionHandler)
    }
    
    class func sendHttpRequest(method : Alamofire.Method, reqUrl : String, body : [String : AnyObject], completionHandler : (AnyObject) -> Void) {
        Alamofire.request(method, reqUrl, parameters: body)
            .responseJSON { response in
                if (response.result.value != nil) {
                    completionHandler(response.result.value!)
                }
                else {
                    print("Error: no response from the server")
                }
        }
    }
    
    // Send a request to the server with the users name, phonenumber and the id of the team they want to join.
    // The server should return a list containing the contact info for each team leader
    class func joinMinistryTeam(ministryTeamId: String, fullName: String, phone: String, callback: (NSArray) -> Void) {
        let url = Config.serverUrl + "api/" + DBCollection.MinistryTeam.name() + "/" + ministryTeamId + "/join"
        let params: [String: AnyObject] = ["name": fullName, "phone": phone]
        
        Alamofire.request(.POST, url, parameters: params).responseJSON {
            response in
            
            if let leaders = response.result.value as? NSArray {
                callback(leaders)
            }
            else {
                print("Error: failed to get leader info")
            }
        }
    }
}