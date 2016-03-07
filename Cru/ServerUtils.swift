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

    static func getById(collectionName : String, id: String, inserter : (NSDictionary) -> ()){
        let requestUrl = Config.serverUrl + "api/" + collectionName + "/" + id
        
        sendHttpGetRequest(requestUrl, completionHandler : {(response : AnyObject) in
            inserter(response as! NSDictionary)
        })
    }
    
    class func loadSpecialResources(collectionName : String, inserter : (NSDictionary) -> ()) {
        loadSpecialResources(collectionName, inserter: inserter, afterFunc: {() in })
    }
    
    class func loadSpecialResources(collectionName : String, inserter : (NSDictionary) -> (), afterFunc : () -> ()) {
        let apiKeyStr = "?" + Config.leaderApiKey + "=" + GlobalUtils.loadString(Config.leaderApiKey)
        let requestUrl = Config.serverUrl + "api/" + collectionName + "/list" + apiKeyStr
        sendHttpGetRequest(requestUrl, completionHandler: insertResources(inserter, afterFunc: afterFunc))
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> ()) {
        loadResources(collectionName, inserter: inserter, afterFunc: {() in })
    }
    
    class func loadResources(collectionName : String, inserter : (NSDictionary) -> (), afterFunc : () -> ()) {
        let requestUrl = Config.serverUrl + "api/" + collectionName + "/list";
        sendHttpGetRequest(requestUrl, completionHandler: insertResources(inserter, afterFunc: afterFunc))
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