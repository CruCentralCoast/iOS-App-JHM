//
//  DBUtils.swift
//  Cru
//
//  Created by Peter Godkin on 11/24/15.
//  Copyright © 2015 Jamaican Hopscotch Mafia. All rights reserved.
//

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
    
//    static func postFakeEvent(idhandler : (String)->()){
//        let url = Config.serverUrl + "api/event/create"
//        let dict = ["slug":"testest",
//            "url":"https://www.facebook.com/events/960196250690072/",
//            "description":"test event",
//            "name":"TEST EVENT",
//            "__v":1,
//            "notificationDate":"2015-10-12T15:00:00.000Z",
//            "parentMinistry":"563b07402930ae0300fbc09b",
//            "imageSquare":[
//                "public_id":"bzvuvdp24teiwrkosvua",
//                "version":1455219064,
//                "signature":"f9b28fd9299e7eabaef3dd9988d83ba702742d3c",
//                "width":1268,
//                "height":1268,
//                "format":"jpg",
//                "resource_type":"image",
//                "url":"http://res.cloudinary.com/dcyhqxvmq/image/upload/v1455219064/bzvuvdp24teiwrkosvua.jpg",
//                "secure_url":"https://res.cloudinary.com/dcyhqxvmq/image/upload/v1455219064/bzvuvdp24teiwrkosvua.jpg"
//            ],
//            "notifications":[
//                
//            ],
//            "parentMinistries":[
//                "563b08df2930ae0300fbc0a0",
//                "563b08fb2930ae0300fbc0a1",
//                "563b090b2930ae0300fbc0a2",
//                "563b091f2930ae0300fbc0a3",
//                "563b07402930ae0300fbc09b",
//                "563b08d62930ae0300fbc09f",
//                "563b08482930ae0300fbc09c",
//                "563b085d2930ae0300fbc09d",
//                "563b094e2930ae0300fbc0a5"
//            ],
//            "rideSharingEnabled":true,
//            "endDate":"2016-10-16T12:00:00.000Z",
//            "startDate":"2016-10-15T19:00:00.000Z",
//            "location":[
//                "postcode":"93001",
//                "state":"CA",
//                "suburb":"Ventura",
//                "street1":"2055 E Harbor Blvd",
//                "country":"United States"
//            ],
//            "image":[
//                "public_id":"devd2faxvvnumpsdkclp",
//                "version":1446711704,
//                "signature":"6537942b4e856bf6acd6ef656f12c6c56d0a2d4f",
//                "width":2048,
//                "height":770,
//                "format":"jpg",
//                "resource_type":"image",
//                "url":"http://res.cloudinary.com/dcyhqxvmq/image/upload/v1446711704/devd2faxvvnumpsdkclp.jpg",
//                "secure_url":"https://res.cloudinary.com/dcyhqxvmq/image/upload/v1446711704/devd2faxvvnumpsdkclp.jpg"
//            ]]
//        
//        Alamofire.request(.POST, url, parameters: dict)
//            .responseJSON { response in
//                if let JSON = response.result.value {
//                    if let dict = JSON as? NSDictionary {
//                        if let postDict = dict["post"] as? NSDictionary{
//                            if let rideid = postDict["_id"] as? String {
//                                idhandler(rideid)
//                            }
//                        }
//                    }
//                }
//        }
//    }
}